package com.example.k4_flutter.Auth;

import com.example.k4_flutter.User.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    private String email;
    private String password;
    private String fullName;
    private String address;
    private String phone;
    private Role role;
}