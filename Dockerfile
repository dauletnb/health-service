# ---- build stage ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# ---- runtime stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app

# Security: run as non-root
RUN useradd -m appuser
USER appuser

COPY --from=build /app/target/*.jar app.jar

ENV SERVICE_NAME="health-service"
ENV SERVICE_PORT=8080

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
