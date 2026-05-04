package com.example.space_registration.repositories;

import com.example.space_registration.models.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<AppUser, Long> {
    // We can add a method to find by username later for login
    Optional<AppUser> findByUsername(String username);
}
