package com.example.k4_flutter.Wallet.Recharge;


import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RechargeRepo  extends JpaRepository<Recharge,Integer> {
    Recharge findByWalletNo(String orderInfo);

    List<Recharge> findByWalletId(Integer id);
}
