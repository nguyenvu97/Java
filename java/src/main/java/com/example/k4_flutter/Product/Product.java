package com.example.k4_flutter.Product;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Getter
@Setter
@Builder
@Table(name = "product")
public class Product {
    @Id
    @SequenceGenerator(name = "product_id_name",sequenceName = "product_id_name" )
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private double price;
    private String productName;
    private int quantity;
    private Integer storeId;
    public LocalDateTime createAt ;
    public LocalDateTime updateAt ;
    public String category;
    public String img;
    private String pathImg;
    @Enumerated(EnumType.STRING)
    private Status status;


}
