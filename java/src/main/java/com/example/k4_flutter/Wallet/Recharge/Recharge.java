package com.example.k4_flutter.Wallet.Recharge;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Recharge {
    @Id
    @SequenceGenerator(name="recharge_id_name",sequenceName ="recharge_id_name" )
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private String walletNo;
    private double rechargeMoney;
    private int walletId;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;
    @Enumerated(EnumType.STRING)
    private RechargeStatus status;
}
