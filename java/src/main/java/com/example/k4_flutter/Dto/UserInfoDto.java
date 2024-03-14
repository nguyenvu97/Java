package com.example.k4_flutter.Dto;

import com.example.k4_flutter.OrderDetails.Order.OrderItem;
import com.example.k4_flutter.OrderDetails.OrderStatus;
import com.example.k4_flutter.Product.Product;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserInfoDto {
    private String phone;
    private String address;
    private double shipMoney;
    private Product product;
    private OrderItem order;
    private String productName;
    private double price;
    private int quantity;
    private int storeId;
    private double money;
    private double totalMoney;
    private String orderNo;
    private Integer userId;
    @Enumerated(EnumType.STRING)
    private OrderStatus orderStatus;

}
