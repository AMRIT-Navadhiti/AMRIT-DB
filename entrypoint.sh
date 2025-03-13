#!/bin/sh

# Detect OS and set Docker host IP dynamically
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
  # Windows Docker Desktop (WSL2)
  DOCKER_HOST_IP="host.docker.internal"
else
  # Linux
  DOCKER_HOST_IP=$(ip route | awk '/default/ { print $3 }')
fi

# Copy the example properties file to create common_local.properties
cp common_example.properties /app/common_local.properties

# Update **all** database connection strings dynamically
sed -i "s|jdbc:mysql://[0-9.]*:3306/|jdbc:mysql://$DOCKER_HOST_IP:3306/|g" /app/common_local.properties

# Run the application with the correct profile
exec mvn spring-boot:run -Dspring-boot.run.profiles=${ENV_VAR}
