package com.example.space_registration.services;

import com.example.space_registration.dto.CampaignDashboardDTO;

import com.example.space_registration.models.Campaign;
import com.example.space_registration.models.Customer;
import com.example.space_registration.models.Ledger;
import com.example.space_registration.models.Enrollment;
import com.example.space_registration.models.TransactionType;

import com.example.space_registration.repositories.CampaignRepository;
import com.example.space_registration.repositories.CustomerRepository;
import com.example.space_registration.repositories.LedgerRepository;
import com.example.space_registration.repositories.EnrollmentRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.math.BigDecimal;

@Service
public class CampaignService {

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private LedgerRepository ledgerRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    public String addCustomerToCampaign(Long customerId, Long campaignId) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        Campaign campaign = campaignRepository.findById(campaignId)
                .orElseThrow(() -> new RuntimeException("Campaign not found"));

        // Logic Check: Count current customers in this campaign
        int currentCount = campaign.getCustomers().size();

        if (currentCount >= campaign.getMaxCustomers()) {
            return "Error: Campaign is full! Limit is " + campaign.getMaxCustomers();
        }

        // If not full, link them
        customer.setCampaign(campaign);
        customerRepository.save(customer);
        return "Success: Customer added to campaign " + campaign.getName();
    }
    

    public CampaignDashboardDTO getCampaignDashboard(Long campaignId) {

    Campaign campaign = campaignRepository.findById(campaignId)
            .orElseThrow(() -> new RuntimeException("Campaign not found"));

    BigDecimal totalCollected  = BigDecimal.ZERO;
    BigDecimal totalDue  = BigDecimal.ZERO;

    // Loop customers
    for (Customer customer : campaign.getCustomers()) {

        // 1️⃣ Sum all payments (Ledger CREDIT)
        List<Ledger> ledgerList  = ledgerRepository.findByCustomer_Id(customer.getId());
        for (Ledger entry : ledgerList ) {
        if (entry.getTransactionType() == TransactionType.CREDIT) {
                totalCollected = totalCollected.add(entry.getAmount());
            } else if (entry.getTransactionType() == TransactionType.DEBIT) {
             totalDue = totalDue.add(entry.getAmount());
            }
        }
    }

    BigDecimal totalRemaining = totalDue.subtract(totalCollected);
    BigDecimal netProfit = totalCollected.subtract(campaign.getAdminInvestment());
    int totalCustomers = campaign.getCustomers().size();

    return new CampaignDashboardDTO(
            campaign.getName(),
            campaign.getAdminInvestment(),
            totalCollected,
            totalRemaining,
            netProfit,
            totalCustomers
    );

    }

    public BigDecimal getCustomerRemainingBalance(Long customerId) {
    return ledgerRepository.findByCustomer_Id(customerId).stream()
            .map(Ledger::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

}
