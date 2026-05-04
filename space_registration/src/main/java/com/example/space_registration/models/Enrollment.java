package com.example.space_registration.models;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name = "enrollments")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Enrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    @JsonBackReference
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private ServiceOffer serviceOffer;
    private boolean isExternal = false;
    private String otherOfficeName;
    private BigDecimal agreedPrice; // The price at the time of joining
}