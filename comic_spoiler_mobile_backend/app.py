import uuid
from flask import Flask, request, jsonify
from flask_cors import CORS
from m_spoiler_detector import run_pipeline
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

# Temporary upload folder
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/')
def home():
    return "Backend is working!"

@app.route('/analyze', methods=['POST'])
def analyze_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'Empty filename'}), 400

    # Save uploaded file
    filename = f"{uuid.uuid4().hex}_{file.filename}"
    image_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(image_path)

    try:
        # Run the pipeline
        result = run_pipeline(image_path)

        # Remove uploaded file after processing
        os.remove(image_path)

        # Build and return JSON response
        return jsonify({
            "extracted_text": result.get("text", ""),
            "caption": result.get("caption", ""),
            "genre": result.get("genre", ""),
            "character_count": result.get("character_count", 0),
            "spoiler_result": result.get("result", "Unknown")
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
