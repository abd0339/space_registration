package com.example.space_registration.repositories;

import com.example.space_registration.models.Ledger;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LedgerRepository extends JpaRepository<Ledger, Long> {
    // This is for your "Money Movement" table
    List<Ledger> findByCustomer_Id(Long customerId);
}