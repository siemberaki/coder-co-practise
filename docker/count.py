import os

from flask import Flask, render_template
import redis

app = Flask(__name__)

redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_port = int(os.environ.get('REDIS_PORT', 6379))
r = redis.Redis(host=redis_host, port=redis_port, db=0, decode_responses=True)

@app.route('/')
def welcome():
    try:
        visits = int(r.get('visits') or 0)
    except redis.RedisError:
        visits = 0

    return render_template('index.html', visits=visits)

@app.route('/count')
def count():
    try:
        visits = r.incr('visits')
    except redis.RedisError:
        return 'Unable to update visit count at this time.', 500

    return render_template('index.html', visits=visits)

@app.route('/health')
def health():
    return {'status': 'ok'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)