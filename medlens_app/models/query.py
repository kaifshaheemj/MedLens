from config.db import db
from bson.objectid import ObjectId
from datetime import datetime

class Query:
    def __init__(self, conversation_id, query_text, image_data=None):
        self.conversation_id = ObjectId(conversation_id)
        self.query_text = query_text
        self.image_data = image_data
        self.create_time = datetime.utcnow()

    @staticmethod
    def create_query(conversation_id, query_text, image_data=None):
        query = {
            "conversation_id": ObjectId(conversation_id),
            "query_text": query_text,
            "image_data": image_data,
            "create_time": datetime.utcnow()
        }
        result = db.queries.insert_one(query)
        return str(result.inserted_id)

    @staticmethod
    def get_queries_by_conversation_id(conversation_id):
        return list(db.queries.find({"conversation_id": ObjectId(conversation_id)}))

    @staticmethod
    def find_query_by_id(query_id):
        return db.queries.find_one({"_id": ObjectId(query_id)})
