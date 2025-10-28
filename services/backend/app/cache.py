"""Redis cache configuration for Flask application."""
from flask_caching import Cache
import os

# Initialize cache object
cache = Cache()

def init_cache(app):
    """Initialize Redis cache with Flask app."""
    redis_url = os.getenv('REDIS_URL', 'redis://localhost:6379/0')
    
    cache_config = {
        'CACHE_TYPE': 'redis',
        'CACHE_REDIS_URL': redis_url,
        'CACHE_DEFAULT_TIMEOUT': 300,
        'CACHE_KEY_PREFIX': 'chatapp_'
    }
    
    app.config.update(cache_config)
    cache.init_app(app)
    
    print(f"✅ Redis cache initialized: {redis_url}")
    return cache

# Decorator for caching functions
def cached(timeout=300, key_prefix='view'):
    """Decorator for caching function results."""
    return cache.cached(timeout=timeout, key_prefix=key_prefix)