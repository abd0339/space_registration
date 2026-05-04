package com.example.space_registration.repositories;

import com.example.space_registration.models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    // This allows us to find customers by their ID or save new ones.
}
