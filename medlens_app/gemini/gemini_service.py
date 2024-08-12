import os
import PIL.Image
from flask import Flask, request, jsonify
import google.generativeai as genai
from dotenv import load_dotenv

# Load the environment variables from .env file
load_dotenv()

app = Flask(__name__)

class Gemini:
    def __init__(self) -> None:
        # Configure the API key for Google Generative AI
        self.api_key = os.getenv("GOOGLE_API_KEY")
        genai.configure(api_key=self.api_key)
        if not self.api_key:
            raise ValueError("API_KEY is not set. Please set it in the .env file")
    
        self.model = genai.GenerativeModel('gemini-1.5-pro', generation_config={"response_mime_type": "application/json"})

    def app_prompt(self, user_input: str = None) -> str:
        base_prompt = """Your name is Medlens. Your job is to analyze the provided image and give detailed information about the medicine or drug it depicts, if applicable. 

Please respond to the user based on the following rules:

1. **If the user provides an image as well as **:
   - Analyze the image for any medicine depicted and provide the following details:
     - Manufacturer
     - Purpose of this Medicine
     - Who can use this medicine
     - Age groups suitable for this medicine
     - Side effects
     - Warnings
     - Dosage
     - Expiry Date
   - If the image does not show a medicine, inform the user that you cannot analyze the image for medical information.

2. **If the user provides text**:
   - Analyze the text for any references to a medicine and provide relevant information based on the text provided.

3. **If the user provides both an image and text**:
   - Analyze both and provide a comprehensive response that includes details from the image and incorporates the user's text.

4. **Additionally, warn the user if**:
   - The medicine appears expired.
   - The medicine may not be suitable for their age group based on limited image analysis.

   For the given input text or image, provide a detailed response to the user.
   If the message from the user is "hello" or "hi", respond with a greeting message as "Hello, This is Medlens. How can I help you today?".
   should be able to provide a detailed response based on the input provided by the user.

**Please note:** This information is for informational purposes only and should not be used as a substitute for professional medical advice. Always consult with a doctor or pharmacist before taking any medication.
"""
        if user_input:
            return f"{base_prompt}\n\nUser input: {user_input}"
        else:
            return base_prompt

    def respond(self, image_path: str = None, user_text: str = None) -> dict:
        prompt = self.app_prompt(user_text)
        print("Prompt:", prompt)
        if image_path and user_text:
            img = PIL.Image.open(image_path)
            response = self.model.generate_content([prompt, img])
        elif image_path:
            img = PIL.Image.open(image_path)
            response = self.model.generate_content([prompt, img])
        elif user_text:
            response = self.model.generate_content([prompt])
        else:
            raise ValueError("No image or text provided for generating a response.")

        print("Response:", response.text)
        return response.text

@app.route('/analyze', methods=['POST'])
def analyze():
    gemini = Gemini()

    # Check for image in the request
    img_file = request.files.get('image')
    img_path = None
    if img_file:
        img_path = f"./temp/{img_file.filename}"
        img_file.save(img_path)

    # Check for text in the request
    user_text = request.form.get('message')

    if not img_path and not user_text:
        return jsonify({'error': 'No image or text provided for analysis.'}), 400

    try:
        response = gemini.respond(image_path=img_path, user_text=user_text)
        return jsonify({'response': response})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    os.makedirs("./temp", exist_ok=True)  # Create temp directory if it doesn't exist
    app.run(port=5000)
