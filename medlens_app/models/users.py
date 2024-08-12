from datetime import datetime
from bson.objectid import ObjectId
from bson.errors import InvalidId
from config.db import db

class User:
    @staticmethod
    def create_user(data):
        user = {
            "username": data['username'].lower(),
            "email": data['email'],
            "password": data['password'],  # In production, hash the password
            "phone_number": data.get('phone_number', None),
            "create_time": datetime.utcnow(),
            "update_time": datetime.utcnow()
        }
        result = db.users.insert_one(user)
        return str(result.inserted_id)

    @staticmethod
    def find_user_by_id(user_id):
        if not ObjectId.is_valid(user_id):
            raise InvalidId("Invalid User ID")
        return db.users.find_one({"_id": ObjectId(user_id)})

    @staticmethod
    def update_user(user_id, update_data):
        if not ObjectId.is_valid(user_id):
            raise InvalidId("Invalid User ID")
        update_fields = {"update_time": datetime.utcnow()}
        update_fields.update(update_data)
        db.users.update_one({"_id": ObjectId(user_id)}, {"$set": update_fields})

    @staticmethod
    def delete_user(user_id):
        if not ObjectId.is_valid(user_id):
            raise InvalidId("Invalid User ID")
        db.users.delete_one({"_id": ObjectId(user_id)})

    @staticmethod
    def get_all_users():
        users = list(db.users.find({}))
        for user in users:
            user['_id'] = str(user['_id'])  # Convert ObjectId to string
        return users
