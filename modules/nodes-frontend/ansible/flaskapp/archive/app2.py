import subprocess
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start_java_app', methods=['POST'])
def start_java_app():
    # Define the command to run the Java program
    command = "sudo su -c 'mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args=\"--failover true --host redis-12001.bamos1-tf-us-west-2-cluster.redisdemo.com --port 12001 --password password --host2 redis-12001.bamos2-tf-us-east-1-cluster.redisdemo.com --port2 12001 --password2 password\"'"

    try:
        # Execute the command and capture output
        process = subprocess.Popen(command, cwd='/tmp/jedis-failover-demo', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        # Capture standard output and standard error
        stdout, stderr = process.communicate()

        # Check if there was an error
        if process.returncode != 0:
            return f'Error starting Java app: {stderr.decode()}'

        # Return the output
        return stdout.decode()
    except Exception as e:
        return f'Error starting Java app: {e}'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
