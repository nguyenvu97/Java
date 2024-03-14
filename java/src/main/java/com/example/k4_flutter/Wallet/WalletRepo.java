package com.example.k4_flutter.Wallet;

import org.springframework.data.jpa.repository.JpaRepository;

public interface WalletRepo extends JpaRepository<Wallet,Integer> {
    Wallet findByEmail(String sub);
}
