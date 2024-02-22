from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start_java_app', methods=['POST'])
def start_java_app():
    # Start the Java Jedis app as a subprocess
    subprocess.Popen(['java', '-jar', 'your_java_jedis_app.jar'])
    return 'Java app started successfully!'

if __name__ == '__main__':
    app.run(debug=True)
