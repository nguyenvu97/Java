package com.example.k4_flutter.Dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class MemberData{
    private Integer id;
    private String sub;
    private Long iat;
    private Long exp;
    private Integer storeId;
    private String shopStatus;
    private double money;
    private String phone;
    private String address;
}