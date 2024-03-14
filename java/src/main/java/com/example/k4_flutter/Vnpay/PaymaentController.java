package com.example.k4_flutter.Vnpay;



import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Dto.ResultDto;
import com.example.k4_flutter.OrderDetails.Order.OrderItem;
import com.example.k4_flutter.OrderDetails.Order.OrderItemRepo;
import com.example.k4_flutter.OrderDetails.OrderDetails;
import com.example.k4_flutter.OrderDetails.OrderDetailsRepo;
import com.example.k4_flutter.OrderDetails.OrderStatus;
import com.example.k4_flutter.Product.Product;
import com.example.k4_flutter.Product.ProductRepo;
import com.example.k4_flutter.Redis_Cart.RedisService;
import com.example.k4_flutter.Wallet.Recharge.Recharge;
import com.example.k4_flutter.Wallet.Recharge.RechargeRepo;
import com.example.k4_flutter.Wallet.Recharge.RechargeStatus;
import com.example.k4_flutter.Wallet.Wallet;
import com.example.k4_flutter.Wallet.WalletRepo;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

import static com.example.k4_flutter.Vnpay.Config.*;


@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("api/vnpay")
public class PaymaentController {
    public final JwtDecoder1 jwtDecoder1;

    public final VnpayRepo vnpayRepo;

    private final WalletRepo walletRepo;
    private final RechargeRepo rechargeRepo;
    private final ProductRepo productRepo;
    private final OrderDetailsRepo orderDetailsRepo;
    private final OrderItemRepo orderItemRepo;

    public final RedisService redisService;
    /*
    *Cart Test
    * Ngân hàng	NCB
Số thẻ	9704198526191432198
Tên chủ thẻ	NGUYEN VAN A
Ngày phát hành	07/15
Mật khẩu OTP	123456
    *
    * */

/*
*
* customer pay
*
* */
    @GetMapping("/payUser")
    public ResponseEntity<?> hashUrl(@RequestHeader("Authorization") String token ,@RequestParam String orderNo) {
        MemberData memberData = jwtDecoder1.decode(token);
        OrderItem order = orderItemRepo.findByEmailAndOrderNo(memberData.getSub(),orderNo);
       if (order == null){
           return null;
       }
        long amount = (long) order.getPayment();
        String vnp_OrderType = order.getOrderNo();
        String vnp_TxnRef = Config.getRandomNumber(8);
        String vnp_IpAddr = "192.168.1.15";
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
        vnp_Params.put("vnp_Command", vnp_Command);
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", "vn");

        vnp_Params.put("vnp_OrderInfo", vnp_OrderType);
        vnp_Params.put("vnp_ReturnUrl", vnp_Returnurl);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_OrderType", vnp_OrderType);
        vnp_Params.put("vnp_BankCode", "NCB");
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        ResultDto storeDto = new ResultDto();
        storeDto.setStatus("200");
        storeDto.setMessger("Successfully");
        storeDto.setDate(LocalDateTime.now());
        storeDto.setUrl(paymentUrl);

        return ResponseEntity.status(HttpStatus.OK).body(storeDto);
    }

    @GetMapping("/domain.vn")
    public String Transaction(
            @RequestParam(value = "vnp_Amount") long amount,
            @RequestParam(value = "vnp_BankCode") String BankCode,
            @RequestParam(value = "vnp_OrderInfo") String OrderInfo,
            @RequestParam(value = "vnp_ResponseCode") String responseCode,
            @RequestParam(value = "vnp_TxnRef") String vnp_TxnRef,
            @RequestParam(value = "vnp_TransactionNo") String vnp_TransactionNo
    ) {
        ResultDto storeDto = new ResultDto();
        if (responseCode.equals("00")) {
            storeDto.setStatus("ok");
            storeDto.setMessger("thanh cong");
            vnpayinfo vnpayinfo1 = new vnpayinfo();
            vnpayinfo1.setAmount(amount / 100);
            vnpayinfo1.setBankCode(BankCode);
            vnpayinfo1.setOrderInfo(OrderInfo);
            vnpayinfo1.setResponseCode(responseCode);
            vnpayinfo1.setVnp_TxnRef(vnp_TxnRef);
            vnpayinfo1.setVnp_TransactionNo(vnp_TransactionNo);
            log.info("orderno =>" + vnp_TxnRef + "\n" + "VnPayAmount =>" + amount);
            OrderItem orderitem = orderItemRepo.findByOrderNo(OrderInfo);


            LocalDateTime createTime = orderitem.getCreateOrder();
            LocalDateTime currentTime = LocalDateTime.now();
            Duration duration = Duration.between(createTime, currentTime);
            long dayBetween = duration.toDays();
//            if (dayBetween >= 3) {
//                orderitem.setStatus(OrderStatus.SUCCESS);
//            } else {
//                orderitem.setStatus(OrderStatus.FAIL);
//            }
            orderitem.setStatus(OrderStatus.SUCCESS);
            orderItemRepo.save(orderitem);
            List<OrderDetails> cartProducts = orderDetailsRepo.findByOrder_id(orderitem.getId());


            for (OrderDetails cartproduct : cartProducts
            ) {
                cartproduct.setOrderStatus(OrderStatus.SUCCESS);
                orderDetailsRepo.save(cartproduct);
                List<Product>productEntities = Collections.singletonList(productRepo.findById(cartproduct.getProduct().getId()).orElse(null));
                for (Product product : productEntities){
                    product.setQuantity(product.getQuantity()-cartproduct.getQuantity());
                }

            }
            vnpayRepo.save(vnpayinfo1);
            String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thành Công </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thành Công</h1>\n" + "    <p>Cảm Ơn Bạn Thanh Toán !</p>\n"  + "</body>\n" + "</html>\n";
            return body;
        }
        String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thất bại </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thất bại</h1>\n"   + "</body>\n" + "</html>\n";
        return body;

    }
//
//
//    /*
//    *
//    * ADMIN PAY STORE
//    *
//    * */
//    @GetMapping("/admin/storePay")
//    public ResponseEntity<?> adminPay(@RequestParam String token) {
//        MemberData memberData = jwtDecoder1.decode(token);
//        RevenouEntity revenou = revenouDao.findByStoreId(memberData.getStoreId());
//        Long amount = (long) revenou.getAfterVatMoney();
//        String vnp_StorePay = revenou.getTransactionalNo();
//        String vnp_TxnRef = Config.getRandomNumber(8);
//        String vnp_IpAddr = "192.168.1.15";
//        Map<String, String> vnp_Params = new HashMap<>();
//        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
//        vnp_Params.put("vnp_Command", vnp_Command);
//        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
//        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
//        String vnp_CreateDate = formatter.format(cld.getTime());
//        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
//        vnp_Params.put("vnp_CurrCode", "VND");
//        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
//        vnp_Params.put("vnp_Locale", "vn");
//        vnp_Params.put("vnp_OrderInfo", vnp_StorePay);
//        vnp_Params.put("vnp_ReturnUrl", vnp_Returnurl1);
//        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
//        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
//        vnp_Params.put("vnp_Version", vnp_Version);
//        vnp_Params.put("vnp_OrderType", vnp_StorePay);
//        vnp_Params.put("vnp_BankCode", "NCB");
//        cld.add(Calendar.MINUTE, 15);
//        String vnp_ExpireDate = formatter.format(cld.getTime());
//        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
//        List fieldNames = new ArrayList(vnp_Params.keySet());
//        Collections.sort(fieldNames);
//        StringBuilder hashData = new StringBuilder();
//        StringBuilder query = new StringBuilder();
//        Iterator itr = fieldNames.iterator();
//        while (itr.hasNext()) {
//            String fieldName = (String) itr.next();
//            String fieldValue = vnp_Params.get(fieldName);
//            if ((fieldValue != null) && (fieldValue.length() > 0)) {
//                //Build hash data
//                hashData.append(fieldName);
//                hashData.append('=');
//                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
//                //Build query
//                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
//                query.append('=');
//                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
//                if (itr.hasNext()) {
//                    query.append('&');
//                    hashData.append('&');
//                }
//            }
//        }
//        String queryUrl = query.toString();
//        String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
//        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
//        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
//        StoreDto storeDto = new StoreDto();
//        storeDto.setStatus("200");
//        storeDto.setMessger("Successfully");
//        storeDto.setDate(LocalDateTime.now());
//        storeDto.setUrl(paymentUrl);
//        return ResponseEntity.status(HttpStatus.OK).body(storeDto);
//    }
//
//    @GetMapping("/storepay")
//    public ResponseEntity<?> TransactionStore(
//            @RequestParam(value = "vnp_Amount") long amount,
//            @RequestParam(value = "vnp_BankCode") String BankCode,
//            @RequestParam(value = "vnp_OrderInfo") String OrderInfo,
//            @RequestParam(value = "vnp_ResponseCode") String responseCode,
//            @RequestParam(value = "vnp_TxnRef") String vnp_TxnRef,
//            @RequestParam(value = "vnp_TransactionNo") String vnp_TransactionNo
//    ) {
//        StoreDto storeDto = new StoreDto();
//        if (responseCode.equals("00")) {
//            storeDto.setStatus("ok");
//            storeDto.setMessger("thanh cong");
//            RevenouEntity revenou = revenouDao.findByTransactionalNo(OrderInfo);
//            revenou.setAfterVatMoney(0);
//            revenou.setStatus(com.microservices.nguyenvu.product.Status.OUT);
//            revenouDao.save(revenou);
//        }
//        return ResponseEntity.status(HttpStatus.OK).body(storeDto);
//    }
//
//    /*
//    *
//    * api recharge
//    * */
//
//    @GetMapping("/success")
//    public String success(){
//
//        String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thành Công </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thành Công</h1>\n" + "    <p>Cảm Ơn Bạn Thanh Toán !</p>\n"  + "</body>\n" + "</html>\n";
//        return body;
//    }
//    @GetMapping("/fail")
//    public String FAIL (){
//
//        String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thất bại </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thất bại</h1>\n"   + "</body>\n" + "</html>\n";
//        return body;
//    }
    @GetMapping("recharge")
    public ResponseEntity<?> hashUrl(@RequestHeader("Authorization") String token, @RequestParam long amountUser, HttpServletRequest request) {
        MemberData memberData = jwtDecoder1.decode(token);
        String vnp_OrderType = randon();
        Wallet wallet = walletRepo.findByEmail(memberData.getSub());
//        String vnp_username = "NGUYEN VAN A";
//        String vnp_card = "9704198526191432198";
//        String cnp_Datetime = "07/15";
        rechargeRepo.save(Recharge
                        .builder()
                        .walletNo(vnp_OrderType)
                        .createAt(LocalDateTime.now())
                        .updateAt(LocalDateTime.now())
                        .status(RechargeStatus.FAIL)
                        .walletId(wallet.getId())
                        .rechargeMoney(amountUser)
                        .build());
        Long amount = amountUser;
        String vnp_TxnRef = Config.getRandomNumber(8);
        String vnp_IpAddr = request.getRemoteAddr();
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
        vnp_Params.put("vnp_Command", vnp_Command);
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_OrderInfo", vnp_OrderType);
        vnp_Params.put("vnp_ReturnUrl", vnp_Returnurl123);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_OrderType", vnp_OrderType);
        vnp_Params.put("vnp_BankCode", "");
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames); // ko co la loi chu ky
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        ResultDto storeDto = new ResultDto();
        storeDto.setStatus("200");
        storeDto.setMessger(vnp_IpAddr);
        storeDto.setDate(LocalDateTime.now());
        storeDto.setUrl(paymentUrl);
        return ResponseEntity.status(HttpStatus.OK).body(storeDto);
    }

    @GetMapping("recharge123")
    public String Transaction1(
            @RequestParam(value = "vnp_Amount") long amount,
            @RequestParam(value = "vnp_BankCode") String BankCode,
            @RequestParam(value = "vnp_OrderInfo") String OrderInfo,
            @RequestParam(value = "vnp_ResponseCode") String responseCode,
            @RequestParam(value = "vnp_TxnRef") String vnp_TxnRef,
            @RequestParam(value = "vnp_TransactionNo") String vnp_TransactionNo
    ) {
        ResultDto storeDto = new ResultDto();
        double money = 0;
        if (responseCode.equals("00")) {
            storeDto.setStatus("ok");
            storeDto.setMessger("thanh cong");
            storeDto.setUrl("http://ok");
            Recharge recharge = rechargeRepo.findByWalletNo(OrderInfo);
            recharge.setStatus(RechargeStatus.OK);
            Wallet wallet = walletRepo.findById(recharge.getWalletId()).orElse(null);
            money = amount + wallet.getWallet();
            wallet.setWallet(money);
            walletRepo.save(wallet);
            String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thành Công </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thành Công</h1>\n" + "    <p>Cảm Ơn Bạn Thanh Toán !</p>\n"  + "</body>\n" + "</html>\n";
           return body;
        }
        String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Thanh Toán Thất bại </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Thanh Toán Thất bại</h1>\n"   + "</body>\n" + "</html>\n";
        return body;

    }

    private String randon() {
        Random random = new Random();
        return "Rechang" + random.nextInt(100);
    }
}
