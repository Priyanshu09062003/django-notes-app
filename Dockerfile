FROM python:3.9

WORKDIR /app/backend

# Install system dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install mysqlclient
COPY requirements.txt /app/backend
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app/backend

# Run migrations (uncomment if needed)
RUN python manage.py migrate
RUN python manage.py makemigrations

EXPOSE 8000

# Start the Django app with Gunicorn (recommended for production)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "your_project.wsgi:application"]

# For development, use Django's runserver (not recommended for production)
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
