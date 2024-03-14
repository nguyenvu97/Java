package com.example.k4_flutter.OrderDetails;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Disconst.Discount;
import com.example.k4_flutter.Disconst.DiscountDao;
import com.example.k4_flutter.Disconst.DiscountService;
import com.example.k4_flutter.Disconst.Statusdiscount;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Dto.UserInfoDto;
import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.OrderDetails.Order.OrderItem;
import com.example.k4_flutter.OrderDetails.Order.OrderItemRepo;
import com.example.k4_flutter.Product.Product;
import com.example.k4_flutter.Product.ProductRepo;
import com.example.k4_flutter.Redis_Cart.RedisService;
import com.example.k4_flutter.Wallet.Wallet;
import com.example.k4_flutter.Wallet.WalletRepo;
import org.hibernate.query.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class OrderDetailsService {
    @Autowired
    public OrderItemRepo orderItemRepo;
    @Autowired
    public OrderDetailsRepo orderDetailsRepo;
    @Autowired
    public JwtDecoder1 jwtDecoder1;
    @Autowired
    public ProductRepo productRepo;
    @Autowired
    public RedisService redisService;
    @Autowired
    public DiscountDao discountDao;
    @Autowired
    public WalletRepo walletRepo;


    // Chek quantity If order pay ok new quantity
    public List<OrderDetails> addProductsToOrder(List<Integer> products, String token, UserInfoDto userInfoDto, String discountCode)
    {
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null) {
            throw new RuntimeException("you can not crate order ");
        }
        String orderNo = orderNo();
        OrderItem orderitem = new OrderItem();
        orderitem.setOrderNo(orderNo);
        orderItemRepo.save(orderitem);

        double totalMoney = 0;
        List<OrderDetails> orderDetailsList = new ArrayList<>();

        for (int product : products) {
            Product productEntity = productRepo.findById(product).orElseThrow(() -> new FindByNotID("Can not find productId" + product));
            double moneyForProduct = productEntity.getPrice() * userInfoDto.getQuantity();
            totalMoney = moneyForProduct + userInfoDto.getShipMoney();

                OrderDetails orderDetails = orderDetailsRepo.save(OrderDetails.builder()
                        .productName(productEntity.getProductName())
                        .product(productEntity)
                        .storeId(productEntity.getStoreId())
                        .price(productEntity.getPrice())
                        .quantity(userInfoDto.getQuantity())
                        .order(orderitem)
                        .orderNo(orderNo)
                        .totalMoney(totalMoney)
                        .img(productEntity.getImg())
                        .userId(memberData.getId())
                        .shipMoney(userInfoDto.getShipMoney())
                        .orderStatus(OrderStatus.AUTH)
                        .build());

                orderDetailsList.add(orderDetails);
            }
        CreateOrderItem(orderNo, token,userInfoDto.getAddress(), userInfoDto.getPhone(),discountCode);
        redisService.deleteProductInCart(products,token);

        return orderDetailsList;
    }


    private String orderNo(){
        long timestamp = System.currentTimeMillis();
        int randomNum = new Random().nextInt(1000);
        return "Order" + timestamp + "-" + randomNum;
    }
    private OrderItem CreateOrderItem(String orderNo,String token,String address ,String phone ,String discountCode)
    {
        if (orderNo == null && token == null){
            return  null;
        }

        MemberData memberData = jwtDecoder1.decode(token);
        double money = 0;
        double sumShipMoney  = 0 ;
        List<OrderDetails> cartProduct = orderDetailsRepo.findByOrderNo(orderNo);
        money = cartProduct.stream().mapToDouble(OrderDetails ::getTotalMoney).sum();
        sumShipMoney =  cartProduct.stream().mapToDouble(OrderDetails::getShipMoney).sum();
        OrderItem orderItem = orderItemRepo.findByOrderNo(orderNo);

        if (orderItem != null) {
            money = applyDiscount(money,discountCode);
            if (isValidDiscountCode(discountCode)) {
                orderItem.setEmail(memberData.getSub());
                orderItem.setUserId(memberData.getId());
                orderItem.setStatus(OrderStatus.AUTH);
                orderItem.setPayment(money);
                orderItem.setUpdateOrder(LocalDateTime.now());
                orderItem.setCreateOrder(LocalDateTime.now());
                orderItem.setAddress(address);
                orderItem.setPhone(phone);
                orderItem.setShipMoney(sumShipMoney);
                orderItemRepo.save(orderItem);
            }

        }
        return  null;
    }
    private double applyDiscount(double total, String discountCode) {
        if(discountCode == ""){
            return total;
        }
                if (isValidDiscountCode(discountCode)) {
                    Discount discount = discountDao.findByCode(discountCode);
                    if (discount != null) {
                        double discountValue = (100 - discount.getDiscountValue()) / 100;
                        total *= discountValue;
                        discount.setStatus(Statusdiscount.USED);
                        discountDao.save(discount);
                        return  total;
                    }
                }
        return -1;
    }

        private boolean isValidDiscountCode(String discountCode) {
            if(discountCode == ""){
                return true;
            }
        Discount discount = discountDao.findByCode(discountCode);
        if (discount != null && discount.getStatus() == Statusdiscount.ACTIVE) {
            LocalDate currentDate = LocalDate.now();
            LocalDate startDate = discount.getStartDate();
            LocalDate endDate = discount.getEndDate();
            return currentDate.isEqual(startDate) || (currentDate.isAfter(startDate) && currentDate.isBefore(endDate));
        }
        return false;
    }
    /*
    History order And Orderdetails
    * */

    public List<OrderItem> historyOrder(String token ){
        if(token == null){
            throw  new RuntimeException(" login anh register");
        }
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            return  null;
        }
        List<OrderItem> orderItem =  orderItemRepo.findByEmailAndStatus(memberData.getSub(),OrderStatus.AUTH);
        return orderItem;
    }
    /*
    orderDetails history for orderNo And get All orderdetails Auth
    * */
    public List<OrderDetails> historyOrderDetails(String orderNo,String token) {
        if (token == null) {
            throw new RuntimeException(" login anh register");
        }
            List<OrderDetails> orderDetails = orderDetailsRepo.findByOrderNoAndOrderStatus(orderNo,OrderStatus.AUTH);
            return orderDetails;
    }
    /*
    Order Not payment status auth
    * */
    public List<OrderItem>listOrderAuth(String token){
        if(token == null){
            throw  new RuntimeException(" login anh register");
        }
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            return  null;
        }
        List<OrderItem> orderItem =  orderItemRepo.findByEmailAndStatus(memberData.getSub(),OrderStatus.AUTH);
        return orderItem;
    }
    /*
    *
    * */
    public String FailOrder(String token, String orderNo){
        if(token == null && orderNo == null){
            throw  new RuntimeException(" login anh register");
        }
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            return  null;
        }
        OrderItem orderItem = orderItemRepo.findByOrderNo(orderNo);
        if (orderItem != null){
            orderItem.setStatus(OrderStatus.FAIL);
            orderItemRepo.save(orderItem);
            List<OrderDetails>chagerStatus = orderDetailsRepo.findByOrder_id(orderItem.getId());
            Optional<OrderDetails>orderDetails = chagerStatus.stream().filter(orderDetails1 -> orderDetails1.getOrderStatus() == OrderStatus.AUTH).findFirst();
            orderDetails.ifPresent(od ->{
                od.setOrderStatus(OrderStatus.FAIL);
                orderDetailsRepo.save(od);
            });


            return "delete Order OK";
        }
        throw new RuntimeException("canh not find by OrderNo" + orderNo);
    }

    /*
    Pay of Amount
    * */
    public MemberData checkToken(String token ){
      MemberData memberData = jwtDecoder1.decode(token);
      if (memberData == null){
          throw new RuntimeException("Can not find by User " + token);
      }
        return memberData;
    }

    public String payAmountUser(String token , String orderNo ){
        double money = 0;
        MemberData memberData= checkToken(token);
       if (orderNo == null && memberData == null){
           throw new RuntimeException("Can not find By" + orderNo);
       }
        Wallet wallet = walletRepo.findByEmail(memberData.getSub());
        OrderItem orderItem = orderItemRepo.findByOrderNo(orderNo);
       if (wallet == null && orderItem == null){
           return null;
       }
        if (wallet.getWallet() >= orderItem.getPayment()){
            money = wallet.getWallet() - orderItem.getPayment();
            wallet.setWallet(money);
            walletRepo.save(wallet);
            orderItem.setStatus(OrderStatus.AUTH);
            orderItemRepo.save(orderItem);
            List<OrderDetails> orderDetails = orderDetailsRepo.findByOrderNo(orderNo);
            for (OrderDetails orderDetails1 : orderDetails){
                orderDetails1.setOrderStatus(OrderStatus.AUTH);
                orderDetailsRepo.save(orderDetails1);
            }
            return "pay amount Ok";
        }
        throw new RuntimeException("you not full amount");

    }

     /*
    count order SUCCESS
    * */
    public int countOrderSUCCESS(String token){
        MemberData memberData= checkToken(token);
        if(memberData == null){
            return -1;
        }
        List<OrderDetails> ListOrder= orderDetailsRepo.findByStoreIdAndOrderStatus(memberData.getStoreId(),OrderStatus.SUCCESS);
        return ListOrder.size();
    }


    /*
    count order FAIL
    * */
    public int countOrderFAIL(String token){
        MemberData memberData= checkToken(token);
        if(memberData == null){
            return -1;
        }
        List<OrderDetails> ListOrder= orderDetailsRepo.findByStoreIdAndOrderStatus(memberData.getStoreId(),OrderStatus.FAIL);
        return ListOrder.size();
    }



    /*
    count order REFUND
    * */
    public int countOrderREFUND(String token){
        MemberData memberData= checkToken(token);
        if(memberData == null){
            return -1;
        }
        List<OrderDetails> ListOrder= orderDetailsRepo.findByStoreIdAndOrderStatus(memberData.getStoreId(),OrderStatus.REFUND);
        return   ListOrder.size();
    }

     /*
    count order UNPAID
    * */
     public int countOrderUNPAID(String token){
         MemberData memberData= checkToken(token);
         if(memberData == null){
             return -1;
         }
         List<OrderDetails> ListOrder= orderDetailsRepo.findByStoreIdAndOrderStatus(memberData.getStoreId(),OrderStatus.UNPAID);
         return   ListOrder.size();
     }
     /*
     HistoryShopBuyOk
     * */
    public List<OrderDetails>HistoryShopBuyOk(String token){
        MemberData memberData= checkToken(token);
        if(memberData == null){
            return null;
        }
        List<OrderDetails> ListOrder= orderDetailsRepo.findByStoreIdAndOrderStatus(memberData.getStoreId(),OrderStatus.SUCCESS);
        return ListOrder;
    }
}
