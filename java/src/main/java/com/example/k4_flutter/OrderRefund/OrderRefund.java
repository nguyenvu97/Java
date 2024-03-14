package com.example.k4_flutter.OrderRefund;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
public class OrderRefund {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    public Integer id;
    private Integer userId;
    private Integer productId;
    private int quantity;
    private String productName;
    private String orderNo;
    private double refundMoney;
    private LocalDateTime createUp;
    private String reason;
    private String img;
}
