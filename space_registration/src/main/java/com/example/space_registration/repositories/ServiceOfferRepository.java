package com.example.space_registration.repositories;

import com.example.space_registration.models.ServiceOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServiceOfferRepository extends JpaRepository<ServiceOffer, Long> {
}