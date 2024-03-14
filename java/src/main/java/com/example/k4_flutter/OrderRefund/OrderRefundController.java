package com.example.k4_flutter.OrderRefund;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/OrderRefund")
public class OrderRefundController {
    @Autowired
    public OrderRefundService orderRefundService;

    @PostMapping()
    public ResponseEntity<?>OrderRefund(@RequestHeader("Authorization") String token, @RequestParam String orderNo ,@RequestParam int productId,@RequestParam String reason ){
        return ResponseEntity.ok().body(orderRefundService.createRefund(token,orderNo,productId,reason));
    }
    @GetMapping("/listOrderRefund")
    public ResponseEntity<?>listOrderRefund(@RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(orderRefundService.getAllOrderRefundForToken(token));
    }
}
