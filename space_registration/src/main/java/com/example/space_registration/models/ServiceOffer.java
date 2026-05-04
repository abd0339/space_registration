package com.example.space_registration.models;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "services")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ServiceOffer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private BigDecimal cost;
    private boolean isInternal; // true = our office, false = external
    private String providerName; // Name of external office if applicable
}