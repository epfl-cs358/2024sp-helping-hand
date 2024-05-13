import base64
from flask import Flask, request, jsonify, Response, make_response
from config import image_to_config


CVserver = Flask(__name__)


# base64 encoded image in request's body
@CVserver.route("/analyse", methods=["POST"])
def analyse():
    b64_img = request.data

    if not b64_img:
        return "image error", 400

    img_data = base64.b64decode(b64_img)
    config = image_to_config(img_data)

    response = make_response(config)
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Credentials", "true")
    response.headers.add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    response.headers.add("Access-Control-Max-Age", "1000")
    response.headers.add("Access-Control-Allow-Headers", "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale")
    return response


# human friendly endpoint to test using an image file upload
@CVserver.route("/analyse-file", methods=["POST"])
def analyse_file():
    # Receive the image file from the POST request
    img_file = request.files["image"]

    if img_file:
        csv_data = image_to_config(img_file.read())

        if csv_data is None:
            return jsonify({"message": "Could not decode image"}), 400

        else:
            return Response(csv_data,
                            mimetype="text/csv",
                            headers={"Content-disposition": "attachment; filename=buttons.csv"})

    else:
        return jsonify({'message': 'No image received'}), 400


# html web interface to upload and analyse a test image file
@CVserver.route('/upload', methods=['GET'])
def upload_form():
    return '''
    <!doctype html>
    <title>Upload an image</title>
    <h1>Upload an image file to analyze:</h1>
    <form method=post enctype=multipart/form-data action="/analyse-file">
      <input type=file name=image>
      <input type=submit value=Upload>
    </form>
    '''


def main():
    CVserver.run(debug=True, host="0.0.0.0", port=5005)


if __name__ == "__main__":
    main()
