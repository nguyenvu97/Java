package com.example.k4_flutter.Redis_Cart;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/redisCart")
public class RedisController {
    @Autowired
    private RedisService redisService;
    @PostMapping("/addCartRedis")
    public ResponseEntity<?> saveRedisCart(@RequestHeader("Authorization")String token, @RequestParam int productId,@RequestParam int quantity){
        return ResponseEntity.ok(redisService.SaveRedisCart(token,productId,quantity));
    }
    @GetMapping("/getAllRedisCart")
    public ResponseEntity<?> getAllRedisCart(@RequestHeader("Authorization")String token){
        return ResponseEntity.ok(redisService.findByUserIdFromToken(token));
    }
    @DeleteMapping("/deleteProductCart")
    public ResponseEntity<String> deleteProductCart(@RequestHeader("Authorization")String token,@RequestParam List<Integer> productId){
        return ResponseEntity.ok(redisService.deleteProductInCart(productId,token));
    }
    @PostMapping("/checkQuantity")
    public ResponseEntity<?> updateQuantityInCart(@RequestHeader("Authorization")String token,@RequestParam Integer productId,@RequestParam int newQuantity){
        return ResponseEntity.ok(redisService.updateQuantityInCart(productId,token,newQuantity));
    }
    @PostMapping("/checkPrice")
    public ResponseEntity<?> updatepriceInCart(@RequestHeader("Authorization")String token,@RequestParam List<Integer>productId){
        return ResponseEntity.ok(redisService.UpdatePrice(token,productId));
    }
}
