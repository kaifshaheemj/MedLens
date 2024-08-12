from flask import Blueprint, request, jsonify
from models.conversation import Conversation

conversation_routes = Blueprint('conversation_routes', __name__)

@conversation_routes.route('/conversations/<user_id>', methods=['GET'])
def get_conversations_by_user_id(user_id):
    conversations = Conversation.get_conversations_by_user_id(user_id)
    return jsonify(conversations), 200

@conversation_routes.route('/conversation', methods=['POST'])
def create_conversation():
    data = request.json
    conversation_id = Conversation.create_conversation(data['user_id'], data.get('description'))
    return jsonify({"conversation_id": conversation_id}), 201
