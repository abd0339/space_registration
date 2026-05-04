package com.example.space_registration;

import com.example.space_registration.models.AppUser;
import com.example.space_registration.models.ServiceOffer;
import com.example.space_registration.repositories.ServiceOfferRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
public class DataSeeder implements CommandLineRunner {

    private final ServiceOfferRepository serviceRepo;
    // Note: If you haven't created UserRepository yet, we will do it below!

    public DataSeeder(ServiceOfferRepository serviceRepo) {
        this.serviceRepo = serviceRepo;
    }

    @Override
    public void run(String... args) throws Exception {
        if (serviceRepo.count() == 0) {
            // Add a sample internal service
            ServiceOffer ticket = new ServiceOffer();
            ticket.setName("Standard VIP Ticket");
            ticket.setCost(new BigDecimal("150.00"));
            ticket.setInternal(true);
            serviceRepo.save(ticket);

            // Add an external service
            ServiceOffer external = new ServiceOffer();
            external.setName("Outside Office Consultation");
            external.setCost(new BigDecimal("50.00"));
            external.setInternal(false);
            external.setProviderName("Global Partners Ltd");
            serviceRepo.save(external);

            System.out.println("--> Sample Services Added to Database!");
        }
    }
}
