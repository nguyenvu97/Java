package com.example.k4_flutter.Totp;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/totp")

public class TotpController {
    @Autowired
    public TotpService totpService;
    @PostMapping("/createOtp")
    public ResponseEntity<?>createOtp(@RequestParam String email){
        return ResponseEntity.ok().body(totpService.authenticateUser(email));
    }
    @GetMapping("/otp")
    public ResponseEntity<?>inputOtp(@RequestParam int otp,@RequestParam String password){
        return  ResponseEntity.ok().body(totpService.verifyOTP(otp,password));
    }
}
