package com.example.k4_flutter.OrderRefund;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRefundRepo extends JpaRepository<OrderRefund,Integer> {
    List<OrderRefund> findByUserId(Integer id);
}
