package com.example.k4_flutter.Disconst;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("api/v1/discounts")
@RequiredArgsConstructor
public class DiscountController {
    private final DiscountService discountService;

    @PostMapping("/create")
    public CompletableFuture<ResponseEntity<Discount>> createDiscount() {
        return discountService.createDiscount()
                .thenApply(createdDiscount -> ResponseEntity.status(HttpStatus.CREATED).body(createdDiscount))
                .exceptionally(ex -> {
                    if (ex.getCause() instanceof IllegalArgumentException) {
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
                    } else {
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
                    }
                });
    }

    @GetMapping("/all")
    public ResponseEntity<Iterable<Discount>> getAlldiscount() {
        return ResponseEntity.status(HttpStatus.OK).body(discountService.getallDiscount());
    }
}