package com.example.k4_flutter.OrderDetails;

import com.example.k4_flutter.OrderDetails.Order.OrderItem;
import com.example.k4_flutter.Product.Product;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class OrderDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer id;
    @ManyToOne
    @JoinColumn(name = "product_id")

    private Product product;
    @ManyToOne
    @JoinColumn(name = "order_id")
    private OrderItem order;
    private String productName;
    private double price;
    private int quantity;
    private int storeId;
    private double totalMoney;
    private double shipMoney;
    private String orderNo;
    private Integer userId;
    private String img;
    @Enumerated(EnumType.STRING)
    private OrderStatus orderStatus;


}
