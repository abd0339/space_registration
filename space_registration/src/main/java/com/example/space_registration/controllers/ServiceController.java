package com.example.space_registration.controllers;

import com.example.space_registration.models.ServiceOffer;
import com.example.space_registration.repositories.ServiceOfferRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/services")
@CrossOrigin(origins = "*")
public class ServiceController {

    @Autowired
    private ServiceOfferRepository serviceOfferRepository;

    // GET all services
    @GetMapping
    public List<ServiceOffer> getAll() {
        return serviceOfferRepository.findAll();
    }

    // CREATE new service
    @PostMapping
    public ServiceOffer create(@RequestBody ServiceOffer service) {
        return serviceOfferRepository.save(service);
    }
}