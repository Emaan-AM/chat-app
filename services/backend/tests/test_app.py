# F:\chat-app\services\backend\tests\test_app.py

from app import create_app  # ✅ correct import — uses backend/app/__init__.py
import sys
import os
# make sure Python can see the parent directory (backend/)
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))


def test_app_exists():
    app = create_app()
    assert app is not None
