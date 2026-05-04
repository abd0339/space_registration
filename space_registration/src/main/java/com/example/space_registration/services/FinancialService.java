package com.example.space_registration.services;

import com.example.space_registration.models.Customer;
import com.example.space_registration.models.Enrollment;
import com.example.space_registration.models.Ledger;
import com.example.space_registration.models.ServiceOffer;
import com.example.space_registration.models.TransactionType;

import com.example.space_registration.repositories.LedgerRepository;
import com.example.space_registration.repositories.EnrollmentRepository;
import com.example.space_registration.repositories.CustomerRepository;
import com.example.space_registration.repositories.ServiceOfferRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.time.LocalDateTime;

@Service
public class FinancialService {

    @Autowired
    private LedgerRepository ledgerRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private CustomerRepository CustomerRepository;

    @Autowired
    private ServiceOfferRepository ServiceOfferRepository;

    // This calculates the "Remaining Amount" for a customer
    public BigDecimal getCustomerBalance(Long customerId) {
        List<Ledger> history = ledgerRepository.findByCustomer_Id(customerId);
        
        BigDecimal totalDue = BigDecimal.ZERO;
        BigDecimal totalPaid = BigDecimal.ZERO;

        for (Ledger entry : history) {
            if (entry.getTransactionType().equals("DEBIT")) {
                totalDue = totalDue.add(entry.getAmount());
            } else if (entry.getTransactionType().equals("CREDIT")) {
                totalPaid = totalPaid.add(entry.getAmount());
            }
        }
        
        return totalDue.subtract(totalPaid);
    }

    @Transactional
    public Enrollment enrollCustomer(Customer customer, ServiceOffer service) {
        // 1. Create the Enrollment
        Enrollment enrollment = new Enrollment();
        enrollment.setCustomer(customer);
        enrollment.setServiceOffer(service);
        enrollment.setAgreedPrice(service.getCost());
        enrollment = enrollmentRepository.save(enrollment);

        // 2. ONLY if internal: Create a DEBIT entry in Ledger (Customer now owes this money)
        if (service.isInternal()) {
            Ledger debt = new Ledger();
            debt.setCustomer(customer);
            debt.setAmount(service.getCost());
            debt.setTransactionType(TransactionType.DEBIT);
            debt.setNote("Charge for service: " + service.getName());
            debt.setTransactionDate(LocalDateTime.now());
            ledgerRepository.save(debt);
        }

        return enrollment;
    }

    @Transactional
    public Ledger collectPayment(Customer customer, BigDecimal amount, String note) {
        Ledger payment = new Ledger();
        payment.setCustomer(customer);
        payment.setAmount(amount);
        payment.setTransactionType(TransactionType.CREDIT);
        payment.setNote(note);
        payment.setTransactionDate(LocalDateTime.now());
        
        return ledgerRepository.save(payment);
    }

    public List<Ledger> getCustomerHistory(Long customerId) {
        // This gets every DEBIT and CREDIT row for this customer
        return ledgerRepository.findByCustomer_Id(customerId);
    }

    public java.util.Map<String, BigDecimal> getGlobalStats() {
        List<Ledger> allTransactions = ledgerRepository.findAll();
        BigDecimal totalCollected = BigDecimal.ZERO;
        BigDecimal totalDebt = BigDecimal.ZERO;

        for (Ledger l : allTransactions) {
            if (l.getTransactionType().equals("CREDIT")) {
                totalCollected = totalCollected.add(l.getAmount());
            } else {
                totalDebt = totalDebt.add(l.getAmount());
            }
        }

        java.util.Map<String, BigDecimal> stats = new java.util.HashMap<>();
        stats.put("totalCollected", totalCollected);
        stats.put("totalOutstandingDebt", totalDebt.subtract(totalCollected));
        return stats;
    }

    @Transactional
    public Enrollment enrollByIds(Long customerId, Long serviceId) {
    Customer customer = CustomerRepository.findById(customerId).orElseThrow();
    ServiceOffer service = ServiceOfferRepository.findById(serviceId).orElseThrow();
    return enrollCustomer(customer, service);
    }



}
