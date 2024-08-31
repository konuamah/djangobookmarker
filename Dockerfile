FROM python:3.12.3-slim

# Update and clean up
RUN apt-get update -qq \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /code

# Copy and install requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt
RUN python -m pip install psycopg[binary]
RUN python -m pip install gunicorn

# Copy the rest of the application
COPY . .

# Set the working directory to where your wsgi.py is located
WORKDIR /code/bookmarks

# Expose port for Gunicorn
EXPOSE 8000

# Start Gunicorn
CMD ["gunicorn", "bookmarks.wsgi:application", "--bind", "0.0.0.0:8000"]
