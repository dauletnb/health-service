# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -q -DskipTests package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

RUN useradd -r -u 1001 appuser
USER appuser

ENV SERVICE_NAME=health-service
ENV SERVICE_PORT=8080

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]