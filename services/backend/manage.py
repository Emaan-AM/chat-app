# manage.py

from app import create_app, db
from flask.cli import FlaskGroup
from helper.models import Message
import os

app = create_app()
cli = FlaskGroup(create_app=create_app)


@cli.command('populate_db')
def populate_db():
    "Populate reset database"
    message = Message(text="First message!")
    db.session.add(message)
    db.session.commit()
    print("✅ Database creation completed")


@cli.command('reset_db')
def recreate_db():
    """Delete and reset database"""
    db.drop_all()
    db.create_all()
    db.session.commit()
    print("✅ Database reset done!")


if __name__ == "__main__":
    # Only start Prometheus metrics if in main child process (avoid debug reload double start)
    if os.environ.get("WERKZEUG_RUN_MAIN") == "true" or not os.environ.get("FLASK_DEBUG"):
        from app.metrics import start_metrics
        start_metrics()

    # Run Flask
    app.run(host="0.0.0.0", port=5000, debug=True)
