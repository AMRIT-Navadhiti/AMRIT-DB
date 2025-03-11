# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set the working directory in the container
WORKDIR /app

# Copy the project files
COPY pom.xml .
COPY src ./src

# Build the project
RUN mvn clean install -DENV_VAR=local

# Expose the application port
EXPOSE 8999

# Pass ENV_VAR to the application
ARG ENV_VAR=local
ENV ENV_VAR=${ENV_VAR}

# Run the application
CMD ["sh", "-c", "mvn spring-boot:run -Dspring-boot.run.profiles=${ENV_VAR}"]
