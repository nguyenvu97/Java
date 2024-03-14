package com.example.k4_flutter.OrderDetails.Order;

import com.example.k4_flutter.OrderDetails.OrderStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Setter
@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private String email;
    private int userId;
    private double payment;
    private String orderNo;
    @Enumerated(EnumType.STRING)
    private OrderStatus status;
    private LocalDateTime createOrder;
    private LocalDateTime updateOrder;
    private String address;
    private String phone;
    private double shipMoney;

}
