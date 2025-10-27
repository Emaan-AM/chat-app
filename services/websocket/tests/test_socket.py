# chat-app/services/websocket/tests/test_socket.py
import pytest
from manage_socket import create_app

def test_socket_app_exists():
    app = create_app()
    assert app is not None
