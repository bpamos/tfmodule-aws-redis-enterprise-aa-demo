from flask import Flask, render_template
from flask_socketio import SocketIO, emit
import subprocess

mvn_command1 = "mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args=\"--failover true --host redis-12001.bamos1-tf-us-west-2-cluster.redisdemo.com --port 12001 --password password --host2 redis-12001.bamos2-tf-us-east-1-cluster.redisdemo.com --port2 12001 --password2 password\""
mvn_command = "${mvn_command}"

app = Flask(__name__)
socketio = SocketIO(app)

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('start_java_app')
def start_java_app():
    # Define the command to run the Java program
    command = mvn_command
    try:
        # Execute the command and capture output
        process = subprocess.Popen(command, cwd='/tmp/jedis-failover-demo', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

        # Send the output from the Java program to the front-end
        for line in iter(process.stdout.readline, b''):
            emit('java_output', line.decode())

        # Wait for the process to complete
        process.wait()
    except Exception as e:
        emit('java_output', f'Error starting Java app: {e}')

if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0')
