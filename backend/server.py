from flask import Flask
from flask_cors import CORS
from controller import questions


app = Flask(__name__)
app.register_blueprint(questions,url_prefix='/question')
CORS(app, supports_credentials=True)

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=9001)