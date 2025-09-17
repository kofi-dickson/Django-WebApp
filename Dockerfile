# Builder Stage: Installs dependencies
FROM python:3.10-slim AS builder

# Sets the working directory inside the container
WORKDIR /usr/src/app

# Copies requirements for build cache optimization
COPY requirements.txt .

# Installs all Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Release Stage: Creates the final, lean image
FROM python:3.10-slim

# Creates and switches to a dedicated non-root user for security
RUN adduser --system appuser
USER appuser

# Sets the application's working directory
WORKDIR /usr/src/app

# Copies the installed packages from the builder stage
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Copies the application code from the host machine to the container
COPY . .

# Exposes the port Gunicorn will listen on
EXPOSE 8000

# Runs the application with Gunicorn, pointing to the correct WSGI file
CMD ["gunicorn", "django_web_app.wsgi:application", "--bind", "0.0.0.0:8000"]
