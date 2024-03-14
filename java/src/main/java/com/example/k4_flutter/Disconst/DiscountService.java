package com.example.k4_flutter.Disconst;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DiscountService {
    public final DiscountDao discountDao;
    @Value("${application.discount.expiration}")
    public int timeLine;


    public CompletableFuture<Discount> createDiscount() {
        LocalDate currentDate = LocalDate.now();
        Random random = new Random();
        double minDiscount = 0.08;
        double discount = 0.15;
        double maxDiccount = 0.2;
        List<Double> listDiscount = new ArrayList<>();
        listDiscount.add(minDiscount);
        listDiscount.add(maxDiccount);
        listDiscount.add(discount);
        int randomDiscount = random.nextInt(listDiscount.size());
        double discountvalue = listDiscount.get(randomDiscount);
        String code = "discount" + random.nextInt(10);
        if (discountDao.findByCode(code) != null) {
            throw new IllegalArgumentException("Mã giảm giá đã tồn tại.");
        } else {
            Discount discount1 = discountDao.save(
                    Discount
                            .builder()
                            .status(Statusdiscount.ACTIVE)
                            .startDate(LocalDate.now())
                            .endDate(currentDate.plus(Period.ofDays(timeLine)))
                            .code(code)
                            .discountValue(discountvalue * 100)
                            .build());
            log.info("cahy den async");
            return CompletableFuture.completedFuture(discount1);
        }
    }

    public void handleExpiredDiscounts() {
        Iterable<Discount> expiredDiscounts = discountDao.findByEndDate(LocalDate.now());

        for (Discount discount : expiredDiscounts) {
            if (discount.getStatus() == Statusdiscount.ACTIVE) {
                discount.setStatus(Statusdiscount.EXPIRED);
                discountDao.save(discount);
            }
        }
    }
    public List <Discount> getallDiscount(){
        List<Discount>discounts =  discountDao.findAll();
        List<Discount>useDiscount = discounts.stream().filter(disocnt -> disocnt.getStatus() == Statusdiscount.ACTIVE).collect(Collectors.toList());
        return useDiscount;
    }
}
