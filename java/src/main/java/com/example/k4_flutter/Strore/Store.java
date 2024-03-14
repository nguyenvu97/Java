package com.example.k4_flutter.Strore;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Getter
@Setter
@Builder
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private String shopName;
    private String shopAddress;
    private String shopPhone;
    @Column( unique = true)
    private String shopEmail;
    @Enumerated(EnumType.STRING)
    private Status status;
    private double storeMoney;
    private String image;
    private String pathImage;
}
