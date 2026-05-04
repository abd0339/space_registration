package com.example.space_registration.dto;

import lombok.*;
import java.math.BigDecimal;

@Data @AllArgsConstructor
public class CampaignDashboardDTO {
    private String campaignName;
    private BigDecimal totalInvested;   // CEO's expenses
    private BigDecimal totalCollected;  // Cash in hand from customers
    private BigDecimal totalRemaining;  // Debt still owed by customers
    private BigDecimal netProfit; // Collected - Invested
    private int totalCustomers;      
}
