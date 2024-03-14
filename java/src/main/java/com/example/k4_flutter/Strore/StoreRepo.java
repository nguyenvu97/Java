package com.example.k4_flutter.Strore;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StoreRepo extends JpaRepository<Store,Integer> {
    Optional<Store> findByShopEmail(String sub);


    Optional<Store> findByImage(String filename);
}
