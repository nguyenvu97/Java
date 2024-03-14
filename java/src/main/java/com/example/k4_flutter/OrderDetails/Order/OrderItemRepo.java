package com.example.k4_flutter.OrderDetails.Order;

import com.example.k4_flutter.OrderDetails.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepo extends JpaRepository<OrderItem,Integer> {

    OrderItem findByOrderNo(String orderInfo);

    OrderItem findByEmailAndOrderNo(String sub, String orderNo);


    List<OrderItem> findByEmailAndStatus(String sub, OrderStatus orderStatus);
}
