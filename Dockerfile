# Use Python 3.9 as the base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app/backend

# Copy only requirements.txt first (better for Docker caching)
COPY requirements.txt /app/backend/

# Install system dependencies required for MySQL client
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . /app/backend

# Expose the port Django will run on
EXPOSE 8000

# Ensure database migrations are applied before starting the server
RUN python manage.py migrate

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
