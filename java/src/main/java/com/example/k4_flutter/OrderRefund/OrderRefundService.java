package com.example.k4_flutter.OrderRefund;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.OrderDetails.Order.OrderItem;
import com.example.k4_flutter.OrderDetails.Order.OrderItemRepo;
import com.example.k4_flutter.OrderDetails.OrderDetails;
import com.example.k4_flutter.OrderDetails.OrderDetailsRepo;
import com.example.k4_flutter.OrderDetails.OrderDetailsService;
import com.example.k4_flutter.OrderDetails.OrderStatus;
import com.example.k4_flutter.Product.Product;
import com.example.k4_flutter.Product.ProductRepo;
import com.example.k4_flutter.Wallet.Wallet;
import com.example.k4_flutter.Wallet.WalletRepo;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@Slf4j
public class OrderRefundService {
    @Autowired
    public OrderRefundRepo orderRefundRepo;
    @Autowired
    public JwtDecoder1 jwtDecoder1;
    @Autowired
    public WalletRepo walletRepo;
    @Autowired
    public OrderDetailsRepo orderDetailsRepo;
    @Autowired
    public OrderItemRepo orderItemRepo;
    @Autowired
    public OrderDetailsService orderDetailsService;
    @Autowired
    public ProductRepo productRepo;



    public OrderRefund createRefund(String token, String orderNo, int productId, String reason) {
        double money = 0;
        if (token != null && orderNo != null && productId > 0) {
            MemberData memberData = jwtDecoder1.decode(token);
            if (memberData != null) {
                OrderItem orderItem = orderItemRepo.findByOrderNo(orderNo);
                if (orderItem != null) {
                    List<OrderDetails> orderDetailsList = orderDetailsRepo.findByOrderNo(orderNo);
                    Optional<OrderDetails> optionalOrderDetails = orderDetailsList.stream()
                            .filter(orderDetails1 -> orderDetails1.getProduct().getId() == productId)
                            .findFirst();

                    if (optionalOrderDetails.isPresent()) {
                        OrderDetails orderDetails = optionalOrderDetails.get();
                        if (orderDetails.getOrderStatus() == OrderStatus.REFUND) {
                            throw new IllegalStateException("Order has already been refunded");
                        }

                        orderDetails.setOrderStatus(OrderStatus.REFUND);
                        orderDetailsRepo.save(orderDetails);

                        Wallet wallet = walletRepo.findByEmail(memberData.getSub());
                        LocalDateTime time = LocalDateTime.now();
                        LocalDateTime createOrderTime = orderItem.getCreateOrder();
                        Duration duration = Duration.between(createOrderTime, time);
                        long minutesDifference = duration.toMinutes();
                        if (CheckTime(minutesDifference)){
                            if (wallet != null ) {

                                OrderRefund refund = orderRefundRepo.save(OrderRefund
                                        .builder()
                                        .createUp(time)
                                        .img(optionalOrderDetails.get().getImg())
                                        .refundMoney(orderDetails.getQuantity() * orderDetails.getPrice())
                                        .orderNo(orderNo)
                                        .userId(memberData.getId())
                                        .quantity(orderDetails.getQuantity())
                                        .productName(orderDetails.getProductName())
                                        .reason(reason)
                                        .productId(productId)
                                        .build());
                                 money += wallet.getWallet() + (orderDetails.getQuantity() * orderDetails.getPrice());
                                wallet.setWallet(money);
                                walletRepo.save(wallet);
                                // update quantity
                                quantityUpdate(productId,orderDetails.getQuantity());

                                if (checkStatusOrderDetails(orderNo)){
                                    orderItem.setPayment(orderItem.getPayment() - (orderDetails.getQuantity() * orderDetails.getPrice()));
                                    orderItem.setStatus(OrderStatus.REFUND);
                                    orderItemRepo.save(orderItem);
                                }else {
                                    orderItem.setPayment(orderItem.getPayment() - (orderDetails.getQuantity() * orderDetails.getPrice()));
                                    orderItemRepo.save(orderItem);
                                }
                                return refund;
                            }
                            orderItem.setStatus(OrderStatus.SUCCESS);
                            orderItemRepo.save(orderItem);
                            orderDetails.setOrderStatus(OrderStatus.SUCCESS);
                            orderDetailsRepo.save(orderDetails);

                        }
                        throw new FindByNotID("can not Refund" + orderNo);

                    }
                }
            }
        }
        throw new EntityNotFoundException("Order not found: " + orderNo);
    }
    private boolean checkStatusOrderDetails(String orderNo) {
        List<OrderDetails> orderDetailsList = orderDetailsRepo.findByOrderNo(orderNo);
        return orderDetailsList.stream()
                .noneMatch(orderDetails -> orderDetails.getOrderStatus() == OrderStatus.AUTH);
    }

    private boolean CheckTime(long time ) {
        return time <= 20;
    }
    public Product quantityUpdate(int productId,int newQuantity){
        Product product = productRepo.findById(productId).orElseThrow(()-> new FindByNotID("can not find by"+ productId));
       product.setQuantity(product.getQuantity() + newQuantity);
       return productRepo.save(product);
    }

     /*
    List<OrderRefund>
    * */
    public  List<OrderRefund>getAllOrderRefundForToken(String token ){
        MemberData memberData = orderDetailsService.checkToken(token);
        List<OrderRefund> orderDetails =  orderRefundRepo.findByUserId(memberData.getId());
        if (memberData != null && orderDetails != null){
            return orderDetails;
        }
        throw new FindByNotID("can not userId" + token);
    }
}
