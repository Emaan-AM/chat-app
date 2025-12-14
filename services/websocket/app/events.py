from flask_socketio import emit
from flask import request
from app.socket import socketio
from app.crud import *
from app.model import *
from app.metrics import REQUESTS


@socketio.on('connect')
def test_connect():
    """Event listener when client has connected to the server"""
    REQUESTS.inc()  # increment Prometheus counter
    print(f"client {request.sid} has connected")
    emit("connect", request.sid, broadcast=True)


@socketio.on("disconnect")
def test_disconnected():
    """Event listener when client disconnects from the server"""
    REQUESTS.inc()  # increment Prometheus counter
    print(f"client {request.sid} has disconnected")
    emit("disconnect", f"user {request.sid} disconnected", broadcast=True)


@socketio.on("new_message")
def new_message(data):
    """Event listener for new messages"""
    REQUESTS.inc()  # increment Prometheus counter
    print(data)
    emit("new_message", data, broadcast=True, include_self=False)
