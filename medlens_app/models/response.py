from config.db import db
from bson.objectid import ObjectId
from datetime import datetime

class Response:
    def __init__(self, query_id, response_text):
        self.query_id = ObjectId(query_id)
        self.response_text = response_text
        self.create_time = datetime.utcnow()

    @staticmethod
    def create_response(query_id, response_text):
        response = {
            "query_id": ObjectId(query_id),
            "response_text": response_text,
            "create_time": datetime.utcnow()
        }
        result = db.responses.insert_one(response)
        return str(result.inserted_id)

    @staticmethod
    def get_responses_by_query_id(query_id):
        return list(db.responses.find({"query_id": ObjectId(query_id)}))

    @staticmethod
    def find_response_by_id(query_id):
        return db.responses.find_one({"query_id": ObjectId(query_id)})
