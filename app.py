import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from gemini.gemini_service import analyze_image

app = Flask(__name__)
CORS(app)

@app.route('/analyze', methods=['POST'])
def analyze():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400
    print("Image accepted")
    image_file = request.files['image']
    image_path = f"./temp/{image_file.filename}"
    image_file.save(image_path)
    print("ImageFile",image_file)
    
    try:
        response = analyze_image(image_path)
        return jsonify({'response': response}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    os.makedirs("./temp", exist_ok=True)
    app.run(host='0.0.0.0', port=5000)
