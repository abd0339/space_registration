package com.example.space_registration.controllers;

import com.example.space_registration.dto.CampaignDashboardDTO;

import com.example.space_registration.models.Campaign;
import com.example.space_registration.models.Customer;
import com.example.space_registration.repositories.CampaignRepository;
import com.example.space_registration.services.CampaignService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.math.BigDecimal;


@RestController
@RequestMapping("/api/campaigns")
@CrossOrigin(origins = "*")
public class CampaignController {

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    private CampaignService campaignService;

    @GetMapping
    public List<Campaign> getAllCampaigns() {
        return campaignRepository.findAll();
    }

    @PostMapping
    public Campaign createCampaign(@RequestBody Campaign campaign) {
        return campaignRepository.save(campaign);
    }

    @PostMapping("/join")
    public String joinCampaign(@RequestParam Long customerId, @RequestParam Long campaignId) {
        return campaignService.addCustomerToCampaign(customerId, campaignId);
    }

    @GetMapping("/{id}/dashboard")
    public CampaignDashboardDTO getDashboard(@PathVariable Long id) {
    return campaignService.getCampaignDashboard(id);
    }

// Endpoint to let Admin update his investment (Bus rent, etc.)
    @PutMapping("/{id}/invest")
    public Campaign updateInvestment(@PathVariable Long id, @RequestParam BigDecimal amount) {
    Campaign campaign = campaignRepository.findById(id).orElseThrow();
    campaign.setAdminInvestment(amount);
    return campaignRepository.save(campaign);
    }

    @GetMapping("/{id}/customers")
    public List<Customer> getCampaignCustomers(@PathVariable Long id) {
        Campaign campaign = campaignRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Campaign not found"));
        return campaign.getCustomers();
    }

}