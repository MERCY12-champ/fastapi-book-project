# Use a lightweight Python image as the base
FROM python:3.13-slim

# Install system dependencies: Nginx and Supervisor
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port 8000 (the port Nginx will listen on)
EXPOSE 8000

# Start Supervisor to run both Uvicorn and Nginx
CMD ["/usr/bin/supervisord", "-n"]
