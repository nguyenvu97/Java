package com.example.k4_flutter.Vnpay;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class vnpayinfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    private long amount;
    private String BankCode;
    private String OrderInfo;
    private String responseCode;
    private String vnp_IpAddrl;
    private String vnp_TxnRef;
    private String vnp_TransactionNo;
}
