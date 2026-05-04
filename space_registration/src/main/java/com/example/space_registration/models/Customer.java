package com.example.space_registration.models;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;



@Entity
@Table(name = "customers")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "campaign_id")
    @JsonIgnore
    private Campaign campaign;
    
    private String firstName;
    private String lastName;
    private String phone;

    // A customer can have many enrollments (services they signed up for)
    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<Enrollment> enrollments;
}