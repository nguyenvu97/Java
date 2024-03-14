package com.example.k4_flutter.OrderDetails;

import com.example.k4_flutter.Dto.ResultDto;
import com.example.k4_flutter.Dto.UserInfoDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("api/v1/orderDetails")
@RequiredArgsConstructor
public class OrderDetailsController {
    @Autowired
    private OrderDetailsService orderDetailsService;
    @PostMapping
    public ResponseEntity<?> savecartItem(
            @RequestHeader("Authorization") String token
            , @RequestParam List<Integer> products
            , @RequestParam (required = false ,value = "discount") String discountCode
            , @RequestBody UserInfoDto userInfoDto)
    {
        List<OrderDetails> orderitem1 = orderDetailsService.addProductsToOrder(products,token,userInfoDto,discountCode);
        if (orderitem1 != null){
            return ResponseEntity.ok(orderitem1);
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ResultDto("not ok","sai roi", LocalDateTime.now(),""));
    }

    @GetMapping("/historyOrder")
    public ResponseEntity<?> historyOrder( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.historyOrder(token));
    }
    @PostMapping("/historyOrderDetails") // se dc goi 2 len 1 lan vs historyOrder 1 lan dc goi vs historyOrderAuth
    public ResponseEntity<?> historyOrderDetails( @RequestHeader("Authorization") String token,@RequestParam String orderNo){
        return ResponseEntity.ok().body(orderDetailsService.historyOrderDetails(orderNo,token));
    }

    @PostMapping("/FailOrder")
    public ResponseEntity<?> failOrder( @RequestHeader("Authorization") String token,@RequestParam String orderNo){
        return ResponseEntity.ok().body(orderDetailsService.FailOrder(token,orderNo));
    }
    @GetMapping("/historyOrderAuth")
    public ResponseEntity<?> historyOrderAuth( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.listOrderAuth(token));
    }
    @PostMapping("/payAmount")
    public ResponseEntity<?> payAmount( @RequestHeader("Authorization") String token,@RequestParam String orderNo){
        return ResponseEntity.ok().body(orderDetailsService.payAmountUser(token,orderNo));
    }


    @GetMapping("/countOrderSUCCESS")
    public ResponseEntity<?> countOrderSUCCESS( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.countOrderSUCCESS(token));
    }
    @GetMapping("/countOrderFAIL")
    public ResponseEntity<?> countOrderFAIL( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.countOrderSUCCESS(token));
    }
    @GetMapping("/countOrderREFUND")
    public ResponseEntity<?> countOrderREFUND( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.countOrderSUCCESS(token));
    }
    @GetMapping("/countOrderUNPAID")
    public ResponseEntity<?> countOrderUNPAID( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.countOrderSUCCESS(token));
    }
    @GetMapping("/HistoryShopBuyOk")
    public ResponseEntity<?> HistoryShopBuyOk( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderDetailsService.HistoryShopBuyOk(token));
    }



}
