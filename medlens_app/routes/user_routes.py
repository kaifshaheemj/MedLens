from flask import Blueprint, request, jsonify
from models.users import User
from bson.errors import InvalidId

user_db = Blueprint('user_bp', __name__)

@user_db.route('/user', methods=['POST'])
def create_user():
    data = request.json
    if not data or not all(key in data for key in ('username', 'email', 'password')):
        return jsonify({"error": "Missing fields in request"}), 400

    user_id = User.create_user(data)
    return jsonify({"user_id": user_id}), 201

@user_db.route('/users', methods=['GET'])
def get_users():
    users = User.get_all_users()
    return jsonify(users), 200

@user_db.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = User.find_user_by_id(user_id)
        if user is None:
            return jsonify({"error": "User not found"}), 404
        user['_id'] = str(user['_id'])
        return jsonify(user), 200
    except InvalidId:
        return jsonify({"error": "Invalid User ID"}), 400

@user_db.route('/user/<user_id>', methods=['PUT'])
def update_user_info(user_id):
    data = request.json
    try:
        User.update_user(user_id, data)
        return jsonify({"message": "User updated successfully"}), 200
    except InvalidId:
        return jsonify({"error": "Invalid User ID"}), 400

@user_db.route('/user/<user_id>', methods=['DELETE'])
def delete_user_info(user_id):
    try:
        User.delete_user(user_id)
        return jsonify({"message": "User deleted successfully"}), 200
    except InvalidId:
        return jsonify({"error": "Invalid User ID"}), 400
