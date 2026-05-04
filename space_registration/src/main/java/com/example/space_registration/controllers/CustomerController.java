package com.example.space_registration.controllers;

import com.example.space_registration.models.Customer;
import com.example.space_registration.models.Campaign;
import com.example.space_registration.repositories.CustomerRepository;
import com.example.space_registration.repositories.CampaignRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*") // Allows your Flutter app to connect
public class CustomerController {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private CampaignRepository campaignRepository;

    // GET all customers: http://localhost:8080/api/customers
    @GetMapping
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    // POST (Add) a new customer
    @PostMapping
    public Customer createCustomer(@RequestBody Customer customer, @RequestParam Long campaignId) {
    Campaign campaign = campaignRepository.findById(campaignId)
            .orElseThrow(() -> new RuntimeException("Campaign not found"));
    customer.setCampaign(campaign);
    return customerRepository.save(customer);
    }


}