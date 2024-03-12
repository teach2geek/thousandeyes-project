# Use Ubuntu 20.04 LTS as base image
FROM ubuntu:20.04

# Prevents Python from writing .pyc files to disc (optional)
ENV PYTHONDONTWRITEBYTECODE=1

# Prevents Python from buffering stdout and stderr (optional)
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Update package list, install Python and pip
RUN apt-get update && \
    apt-get install -y python3-pip python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container at /app
COPY ./requirements.txt /app/requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Create a non-privileged user 'teappuser' to run the app
# Define the UID for the non-privileged user.
ARG UID=10000

# Create a non-privileged user 'teappuser' with specific properties.
  # --disabled-password Disable password for this user for security reasons.
  # --gecos Skip filling in the GECOS fields to avoid unnecessary user info.
  # --home "/nonexistent"  Specify the user's home directory. Using "/nonexistent" as this user doesn't require a home directory.
  # --shell "/sbin/nologin" Set the login shell to '/sbin/nologin' to prevent interactive login.
  # --no-create-home Do not create the user's home directory.
  # --uid "${UID}" Set the user's UID to the value specified by the 'UID' argument.
  # teappuser The username for the non-privileged user.
RUN adduser --disabled-password --gecos "" --home "/nonexistent" --shell "/sbin/nologin" --no-create-home --uid "${UID}" teappuser

# Switch to the non-privileged user
USER teappuser

# Copy the rest of your application's code into the container at /app
COPY . .

# Expose port 80 to the outside world
EXPOSE 80

# Define environment variables for AWS Secrets Manager
ENV AWS_SECRET_NAME=prod/te-app/oauth_token
ENV AWS_REGION=us-east-2

# Run the application
CMD ["python3", "te-appv2.py"]
