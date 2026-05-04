package com.example.space_registration.controllers;

import com.example.space_registration.models.Customer;
import com.example.space_registration.models.ServiceOffer;
import com.example.space_registration.models.Ledger;

import com.example.space_registration.services.FinancialService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;



@RestController
@RequestMapping("/api/finance")
@CrossOrigin(origins = "*")
public class FinancialController {

    @Autowired
    private FinancialService financialService;
    @Autowired
    private com.example.space_registration.repositories.CustomerRepository customerRepo;
    @Autowired
    private com.example.space_registration.repositories.ServiceOfferRepository serviceRepo;

    // GET balance: http://localhost:8080/api/finance/balance/{customerId}
    @GetMapping("/balance/{id}")
    public BigDecimal getBalance(@PathVariable Long id) {
        return financialService.getCustomerBalance(id);
    }

    @PostMapping("/enroll")
    public String enroll(@RequestParam Long customerId, @RequestParam Long serviceId) {
        Customer customer = customerRepo.findById(customerId).get();
        ServiceOffer service = serviceRepo.findById(serviceId).get();
        
        financialService.enrollCustomer(customer, service);
        return "Customer enrolled and debt recorded!";
    }

    @PostMapping("/pay")
    public Ledger pay(@RequestParam Long customerId, @RequestParam BigDecimal amount, @RequestParam String note) {
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> new RuntimeException("Customer not found"));
        
        return financialService.collectPayment(customer, amount, note);
    }

    @GetMapping("/history/{id}")
    public List<Ledger> getHistory(@PathVariable Long id) {
        return financialService.getCustomerHistory(id);
    }

    @GetMapping("/stats")
    public java.util.Map<String, BigDecimal> getGlobalStats() {
        return financialService.getGlobalStats();
    }
    
}