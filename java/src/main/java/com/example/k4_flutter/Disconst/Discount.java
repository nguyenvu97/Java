package com.example.k4_flutter.Disconst;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Discount implements Serializable {
    @Id
    @SequenceGenerator(name = "discount_id_name",sequenceName ="discount_id_name" )
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    @Column(unique = true)
    private String code;
    private double discountValue;
    private LocalDate startDate;
    @Column(name = "end_date")
    private LocalDate endDate;
    @Enumerated(EnumType.STRING)
    private Statusdiscount status;
}