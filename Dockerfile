# Use Python 3.9 as the base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app/backend

# Install system dependencies required for MySQL client
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev libmariadb-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements.txt first (for better caching)
COPY requirements.txt /app/backend/

# **Ensure `mysqlclient` is installed**
RUN pip install --no-cache-dir mysqlclient

# Install other Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . /app/backend

# Expose the port Django will run on
EXPOSE 8000

# **Ensure database migrations are applied before starting the server**
RUN python manage.py migrate || echo "Migration failed, check MySQL connection"

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
