# Stage 1: Build stage for installing dependencies
FROM ubuntu:20.04 as builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3-pip python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, and wheel, then install the requirements
COPY requirements.txt .
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt

# Stage 2: Production stage for running the app
FROM ubuntu:20.04 as production

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install only the Python runtime
RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*

# Copy Python runtime dependencies from builder stage
COPY --from=builder /usr/local/lib/python3.*/dist-packages /usr/local/lib/python3.8/dist-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Create a non-privileged user with a home directory
ARG UID=10000
RUN mkdir -p /home/teappuser && \
    adduser --disabled-password --gecos "" --home /home/teappuser --shell "/sbin/nologin" --no-create-home --uid "${UID}" teappuser && \
    chown -R teappuser:teappuser /home/teappuser
USER teappuser


# Copy the rest of your application's code into the container
COPY . .

EXPOSE 80
ENV AWS_SECRET_NAME=prod/te-app/oauth_token
ENV AWS_REGION=us-east-2

CMD ["python3", "teapp.py"]
