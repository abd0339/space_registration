package com.example.space_registration.models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class AppUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String password;
    private String role; // "ADMIN" or "EMPLOYEE"
    private boolean isActive = true; // For "pausing" an employee
}