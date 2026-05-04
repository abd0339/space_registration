package com.example.space_registration.repositories;

import com.example.space_registration.models.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    // Find all services a specific customer is enrolled in
    List<Enrollment> findByCustomerId(Long customerId);
}