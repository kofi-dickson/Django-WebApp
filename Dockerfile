#Use an official Python runtime as a parent image
FROM python:3.10-slim

#Set the working directory in the container
WORKDIR /usr/src/app

#Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=django_web_app.settings

#Install dependencies
COPY ./requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

#Copy the rest of the project into the working directory
COPY . .

#Run collectstatic to prepare static files
RUN python manage.py collectstatic --noinput

#Expose the port Gunicorn will listen on
EXPOSE 8000

#Run Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_web_app.wsgi:application"]
