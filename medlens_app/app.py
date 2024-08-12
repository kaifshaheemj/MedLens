from flask import Flask, request, jsonify
from gemini.gemini_service import analyze_image
from routes.user_routes import user_db
from routes.conversation_routes import conversation_routes
from routes.query_routes import query_routes
from routes.response_routes import response_routes
import os

app = Flask(__name__)

app.register_blueprint(user_db, url_prefix='/api')
app.register_blueprint(conversation_routes, url_prefix='/api')
app.register_blueprint(query_routes, url_prefix='/api')
app.register_blueprint(response_routes, url_prefix='/api')

@app.route('/analyze', methods=['POST'])
def analyze():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    img_file = request.files['image']
    
    # Ensure the temp directory exists
    if not os.path.exists('./temp'):
        os.makedirs('./temp')
    
    img_path = f"./temp/{img_file.filename}"
    
    try:
        img_file.save(img_path)
        response = analyze_image(img_path)
        return jsonify({'response': response})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
