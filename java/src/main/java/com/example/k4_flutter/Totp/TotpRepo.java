package com.example.k4_flutter.Totp;

import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TotpRepo extends JpaRepository<Totp,Integer> {


    Totp findByNumberAndExp(int otp, boolean b);
}
