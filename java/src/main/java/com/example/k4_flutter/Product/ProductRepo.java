package com.example.k4_flutter.Product;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProductRepo extends JpaRepository<Product,Integer> {

    List<Product> findByProductNameContaining(String keyword);

    List<Product> findByStoreId(Integer id);

    Optional<Product> findByImg(String filename);

    List<Product> findTop4ByAndStoreIdOrderByIdDesc(PageRequest of, Integer storeId);

//    List<Product> findTop4ByOrderByIdDescStoreId(PageRequest of, Integer storeId);

    
}
