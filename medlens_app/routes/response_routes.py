from flask import Blueprint, request, jsonify
from models.response import Response

response_routes = Blueprint('response_routes', __name__)

@response_routes.route('/responses/<query_id>', methods=['GET'])
def get_responses_by_query_id(query_id):
    responses = Response.get_responses_by_query_id(query_id)
    return jsonify(responses), 200

@response_routes.route('/response', methods=['POST'])
def create_response():
    data = request.json
    response_id = Response.create_response(data['query_id'], data['response_text'])
    return jsonify({"response_id": response_id}), 201
