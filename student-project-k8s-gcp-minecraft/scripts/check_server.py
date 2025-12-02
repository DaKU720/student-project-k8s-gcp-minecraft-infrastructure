import sys
import socket

def check_server(host, port=25565):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(3)
    try:
        result = sock.connect_ex((host, port))
        if result == 0:
            print(f"SUCCESS: Server {host}:{port} is ONLINE!")
        else:
            print(f"FAILURE: Server {host}:{port} is OFFLINE.")
    except Exception as e:
        print(f"ERROR: {e}")
    finally:
        sock.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 check_server.py <IP_ADDRESS>")
    else:
        check_server(sys.argv[1])