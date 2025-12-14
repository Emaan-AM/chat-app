from prometheus_client import start_http_server, Counter

start_http_server(5001)
REQUESTS = Counter('http_requests_total', 'Total HTTP Requests')
