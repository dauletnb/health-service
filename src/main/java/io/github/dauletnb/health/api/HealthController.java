package io.github.dauletnb.health.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    private final String serviceName;

    public HealthController(@Value("${service.name}") String serviceName) {
        this.serviceName = serviceName;
    }

    @GetMapping("/health")
    public HealthResponse health() {
        return new HealthResponse("UP", serviceName);
    }
}