package com.example.k4_flutter.Disconst;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;

public interface DiscountDao extends JpaRepository<Discount,Integer> {
    Discount findByCode(String discountCode);

    Iterable<Discount> findByEndDate(LocalDate currentDate);
}
