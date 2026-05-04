package com.example.space_registration.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;
import java.math.BigDecimal;

@Entity
@Table(name = "campaigns")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Campaign {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private LocalDate startDate;
    private BigDecimal adminInvestment = BigDecimal.ZERO;
    private int maxCustomers; // The limit you mentioned
    
    // Links many customers to one campaign
    @OneToMany(mappedBy = "campaign")
    private List<Customer> customers;
}