# app/metrics.py
from prometheus_client import start_http_server, Counter
import os

# Example Prometheus metric
REQUESTS = Counter('app_requests_total', 'Total HTTP requests')

def start_metrics(port: int = 5006):
    """Start Prometheus metrics server safely."""
    try:
        start_http_server(port)
        print(f"✅ Prometheus metrics server started on port {port}")
    except OSError as e:
        print(f"⚠️ Could not start Prometheus metrics server: {e}")
