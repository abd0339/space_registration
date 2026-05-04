package com.example.space_registration.models;

import com.example.space_registration.models.TransactionType;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "ledger")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Ledger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    @JsonIgnore
    private Customer customer;

    private BigDecimal amount;
    
    // "DEBIT" for a new charge, "CREDIT" for a payment received
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionType transactionType;

    private LocalDateTime transactionDate = LocalDateTime.now();
    
    private String note; // e.g., "Paid cash for Ticket #123"

}