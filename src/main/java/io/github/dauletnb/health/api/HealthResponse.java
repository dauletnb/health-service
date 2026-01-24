package io.github.dauletnb.health.api;

public record HealthResponse(
        String status,
        String service
) {}