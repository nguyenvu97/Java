package com.example.k4_flutter.Redis_Cart;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Cart implements Serializable {

    private Integer productId;
    private double price;
    private String productName;
    private int quantity;
    private Integer storeId;
    public String img;
    private String pathImg;
    private Integer UserId;
}
