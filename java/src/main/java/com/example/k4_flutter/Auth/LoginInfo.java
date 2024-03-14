package com.example.k4_flutter.Auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class LoginInfo {
    private int attempts;
    private LocalDateTime lastAttempt;
}