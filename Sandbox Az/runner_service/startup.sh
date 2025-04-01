#!/bin/bash
set -e

#Set ulimit to enable more threads
ulimit -u 4096

ulimit -u

# Start the app
echo "Starting Gunicorn server..."
exec gunicorn --bind=0.0.0.0:${PORT:-8000} \
     --workers=2 \
     --threads=4 \
     --timeout=300 \
     --access-logfile=- \
     --error-logfile=- \
     --log-level=info \
     run_server:app
