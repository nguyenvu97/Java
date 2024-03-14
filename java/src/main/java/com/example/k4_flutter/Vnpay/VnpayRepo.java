package com.example.k4_flutter.Vnpay;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VnpayRepo extends JpaRepository<vnpayinfo,Long> {
}
