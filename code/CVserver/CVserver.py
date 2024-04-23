from flask import Flask, request, jsonify, Response
from process_image import process_image
import cv2
import numpy as np

CVserver = Flask(__name__)

@CVserver.route('/analyse', methods=['POST'])
def analyse_image():
    # Receive the image file from the POST request
    img_file = request.files['image']

    if img_file:
        csv_data = process_image(img_file.read())

        if csv_data is None:
            return jsonify({'message': 'Could not decode image'}), 400

        else:
            return Response(csv_data,
                            mimetype='text/csv',
                            headers={"Content-disposition": "attachment; filename=buttons.csv"})

    else:
        return jsonify({'message': 'No image received'}), 400

@CVserver.route('/upload', methods=['GET'])
def upload_form():
    return '''
    <!doctype html>
    <title>Upload an image</title>
    <h1>Upload an image file to analyze:</h1>
    <form method=post enctype=multipart/form-data action="/analyse">
      <input type=file name=image>
      <input type=submit value=Upload>
    </form>
    '''

if __name__ == '__main__':
    CVserver.run(debug=True, host='0.0.0.0', port=5005)
