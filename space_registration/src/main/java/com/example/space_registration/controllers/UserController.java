package com.example.space_registration.controllers;

import com.example.space_registration.models.AppUser;
import com.example.space_registration.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<AppUser> getAllUsers() {
        return userRepository.findAll();
    }

    @PostMapping
    public AppUser createUser(@RequestBody AppUser user) {
        return userRepository.save(user);
    }

    // This handles "Pausing" an employee
    @PutMapping("/{id}/toggle-status")
    public AppUser toggleStatus(@PathVariable Long id) {
    AppUser user = userRepository.findById(id).orElseThrow();
    user.setActive(!user.isActive());
    
    return userRepository.save(user);
    }
    
}