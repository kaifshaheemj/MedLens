from flask import Blueprint, request, jsonify
from models.query import Query

query_routes = Blueprint('query_routes', __name__)

@query_routes.route('/queries/<conversation_id>', methods=['GET'])
def get_queries_by_conversation_id(conversation_id):
    queries = Query.get_queries_by_conversation_id(conversation_id)
    return jsonify(queries), 200

@query_routes.route('/query', methods=['POST'])
def create_query():
    data = request.json
    query_id = Query.create_query(data['conversation_id'], data['query_text'], data.get('image_data'))
    return jsonify({"query_id": query_id}), 201
