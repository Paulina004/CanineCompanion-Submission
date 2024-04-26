from flask import Flask, request, jsonify
from flask_cors import CORS
from dog_bot import DogBot

app = Flask(__name__)
CORS(app)
dog_bot = DogBot()

@app.route('/query', methods=['POST'])
def handle_query():
    if not request.json or 'query' not in request.json:
        return jsonify({'error': 'Invalid request. Query missing.'}), 400

    query = request.json['query']
    try:
        response = dog_bot.query_handler(query)
        return jsonify({'message': response})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
