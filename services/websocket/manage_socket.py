#chat-app/services/websocket/manage-socket.py
from flask import Flask
from flask_cors import CORS
from app import socketio, db
import os
from dotenv import load_dotenv

def create_app():
    # ✅ Load environment variables from .env file
    load_dotenv()

    app_settings = os.getenv("WEBSOCKET_APP_SETTINGS", os.getenv("APP_SETTINGS"))
    app = Flask(__name__)

    # ✅ Load Flask config class (if defined)
    if app_settings:
        app.config.from_object(app_settings)

    # ✅ Read DB settings from environment
    db_user = os.getenv("POSTGRES_USER")
    db_pass = os.getenv("POSTGRES_PASSWORD")
    db_name = os.getenv("POSTGRES_DB")
    db_host = os.getenv("DB_HOST", "localhost")  # fallback for local runs
    db_port = os.getenv("DB_PORT", "5432")

    # ✅ Compose database URI dynamically
    app.config["SQLALCHEMY_DATABASE_URI"] = (
        f"postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"
    )
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.secret_key = os.getenv("SECRET_KEY", "defaultsecret")

    CORS(app, resources={r"/*": {"origins": "*"}})

    db.init_app(app)
    register_extensions(app)
    return app

def register_extensions(app):
    socketio.init_app(app, async_mode='eventlet', cors_allowed_origins="*")
