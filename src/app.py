from flask import Flask
import socket

app = Flask(__name__)
 
@app.route('/')
@app.route('/home')
def home():
    # Get the IP address of the Ethernet interface
    global ip_address
    ip_address = get_ip_address()
    return f"Welcome to test application! Your IP address is {ip_address} "
 
def get_ip_address():
    try:
        # Create a socket connection to determine the local IP address
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip_address = s.getsockname()[0]
        s.close()
        return ip_address
    except Exception as e:
        return f"Error: {e}"
 

