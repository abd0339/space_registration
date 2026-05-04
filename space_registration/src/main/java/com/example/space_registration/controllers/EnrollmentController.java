package com.example.space_registration.controllers;

import com.example.space_registration.models.Enrollment;
import com.example.space_registration.services.FinancialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/enrollments")
@CrossOrigin(origins = "*")
public class EnrollmentController {

    @Autowired
    private FinancialService financialService;

    /**
     * This endpoint handles the 'Click' from Flutter.
     * It uses the helper method we added to FinancialService.
     */
    @PostMapping
    public ResponseEntity<?> enroll(@RequestParam Long customerId, @RequestParam Long serviceId) {
        try {
            Enrollment enrollment = financialService.enrollByIds(customerId, serviceId);
            return ResponseEntity.ok(enrollment);
        } catch (Exception e) {
            // Return the error so we can see it in the Flutter console
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}