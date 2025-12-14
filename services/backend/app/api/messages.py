from flask import request
from flask_restx import Namespace, Resource, fields
from helper.crud import get_all_messages, add_message
from app.metrics import REQUESTS


message_namespace = Namespace("message")

message_model = message_namespace.model(
    "Message",
    {
        "id": fields.Integer(readOnly=True),
        "text": fields.String(required=True),
        "date": fields.Date,
    },
)


class Messages(Resource):
    @message_namespace.marshal_with(message_model, as_list=True)
    def get(self):
        REQUESTS.inc()  # increment Prometheus counter
        messages = get_all_messages()
        return messages, 200

    @message_namespace.expect(message_model, validate=True)
    def post(self):
        REQUESTS.inc()  # increment Prometheus counter
        post_data = request.get_json()
        text = post_data.get("text")
        latest_message = add_message(text)

        if latest_message.get("status") == "error":
            print(latest_message)
            return latest_message, 400

        return latest_message, 200


message_namespace.add_resource(Messages, "")
