from config.db import db
from bson.objectid import ObjectId
from datetime import datetime

class Conversation:
    def __init__(self, user_id, description=None):
        self.user_id = ObjectId(user_id)
        self.description = description
        self.create_time = datetime.utcnow()

    @staticmethod
    def create_conversation(user_id, description=None):
        conversation = {
            "user_id": ObjectId(user_id),
            "description": description,
            "create_time": datetime.utcnow()
        }
        result = db.conversations.insert_one(conversation)
        return str(result.inserted_id)

    @staticmethod
    def get_conversations_by_user_id(user_id):
        return list(db.conversations.find({"user_id": ObjectId(user_id)}))

    @staticmethod
    def find_conversation_by_id(conversation_id):
        return db.conversations.find_one({"_id": ObjectId(conversation_id)})
