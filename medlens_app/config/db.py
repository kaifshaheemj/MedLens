from pymongo import MongoClient
from dotenv import load_dotenv
import os
from bson.objectid import ObjectId
from pymongo.errors import ConnectionFailure
load_dotenv()

client = MongoClient(os.getenv("MONGO_URI"))
db = client['medlens']

