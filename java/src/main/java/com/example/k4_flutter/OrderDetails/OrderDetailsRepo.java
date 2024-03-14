package com.example.k4_flutter.OrderDetails;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderDetailsRepo extends JpaRepository<OrderDetails,Integer> {
    List<OrderDetails> findByOrder_id(Integer id);


    List<OrderDetails> findByOrderNo(String orderNo);

    List<OrderDetails> findByOrderNoAndOrderStatus(String orderNo, OrderStatus orderStatus);

    List<OrderDetails> findByStoreId(Integer storeId);

    List<OrderDetails> findByStoreIdAndOrderStatus(Integer storeId, OrderStatus orderStatus);
}
