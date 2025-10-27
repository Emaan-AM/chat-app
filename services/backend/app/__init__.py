# app/__init__.py
from dotenv import load_dotenv
import os
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy


load_dotenv()
cors = CORS()
db = SQLAlchemy()
 
def create_app(script_info=None):

    #set flask app settings from environmental variables set in docker-compose
    app_settings = os.getenv("BACKEND_APP_SETTINGS")

    #instantiate app
    app = Flask(__name__)
    
    #set configs
    app.config.from_object(app_settings)

    #set extensions
    cors.init_app(
        app,
        resources= {r"*": {"origins": "*", "allow_headers": "*", "expose_headers": "*"}},
        supports_credentials= True
    )
    db.init_app(app)

    #register api
    from app.api import api
    api.init_app(app)

    @app.shell_context_processor
    def ctx():
        return {"app":app,"db":db}

    return app