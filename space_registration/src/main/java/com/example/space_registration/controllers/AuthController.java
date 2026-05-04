package com.example.space_registration.controllers;

import com.example.space_registration.models.AppUser;
import com.example.space_registration.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");

        Optional<AppUser> userOpt = userRepository.findByUsername(username);

        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            AppUser user = userOpt.get();
            if (!user.isActive()) {
                return ResponseEntity.status(403).body(Map.of("message", "Account is paused by Admin"));
            }
            return ResponseEntity.ok(Map.of(
                "status", "success",
                "role", user.getRole(),
                "username", user.getUsername()
            ));
        }
        return ResponseEntity.status(401).body(Map.of("message", "Invalid username or password"));
    }
}