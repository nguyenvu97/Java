package com.example.k4_flutter.Wallet;

import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@Entity
@NoArgsConstructor
@Table(name = "wallet")
public class Wallet {
    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Integer id;
    private double wallet;
    private String email;
    private String phoneNo;
}
