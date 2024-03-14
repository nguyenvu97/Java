package com.example.k4_flutter.Wallet.Recharge;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/v1/recharger")
public class RechargeController {

    @Autowired
    public RechargeService rechargeService;
    @PostMapping
    public ResponseEntity<?> historyRecharge(@RequestHeader("Authorization") String token){
        return ResponseEntity.ok(rechargeService.historyRechargeUser(token));
    }

}
