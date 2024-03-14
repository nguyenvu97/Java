package com.example.k4_flutter.Strore;

import com.example.k4_flutter.Product.Product;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

import static org.springframework.http.MediaType.valueOf;

@RestController
@RequestMapping("/api/v1/store")
public class StoreController {
    @Autowired
    public StoreService storeService;

    @PostMapping("/create")
    public ResponseEntity<?> OpenStrore(@RequestHeader("Authorization") String token) {
        return ResponseEntity.status(HttpStatus.CREATED).body(storeService.CreateStore(token));
    }

    @GetMapping("/deleteShop")
    public ResponseEntity<String> offShop(@RequestHeader("Authorization") String token) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.OffStore(token));
    }

    @GetMapping("/storeId")
    public ResponseEntity<?> GetProductinStoreId(@RequestHeader("Authorization") String token) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.findByProductIdForStore(token));
    }

    @PostMapping("paymentStore")
    public ResponseEntity<?> payMentStore(@RequestHeader("Authorization") String token, @RequestParam double money) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.paymentShop(token, money));
    }

    @GetMapping("/top3Product")
    public ResponseEntity<?> top3Product(@RequestHeader("Authorization") String token) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.getTop3ProductInShop(token));
    }

    @GetMapping("/countCategory")
    public ResponseEntity<?> countCategory(@RequestHeader("Authorization") String token,@RequestParam String category) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.getCategoryStoreId(token,category));
    }
    @GetMapping("/storeInfo")
    public ResponseEntity<?> storeInfo(@RequestHeader("Authorization") String token) {
        return ResponseEntity.status(HttpStatus.OK).body(storeService.storeInfo(token));
    }
    @PostMapping("/updateStore")
    public ResponseEntity<?> updateStore(@RequestHeader("Authorization") String token,
                                         @RequestParam(required = false,value = "image") MultipartFile image,
                                         @RequestParam(value = "store") String store)  {
        try{
            ObjectMapper objectMapper = new ObjectMapper();
            Store store1 = objectMapper.readValue(store,Store.class);
            return  ResponseEntity.ok().body(storeService.updateStore(token,store1,image));
        }catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("null");
        }
    }
    @PostMapping("/chageImage")
    public ResponseEntity<?> chageImage(@RequestHeader("Authorization") String token,
                                     @RequestParam(required = false,value = "image") MultipartFile image){
        return  ResponseEntity.ok().body(storeService.updateImage(token,image));
    }
    @GetMapping("/fileSystem/{filename}")
    public ResponseEntity<?> downloadImageFromFileSystem(@PathVariable String filename) throws IOException {
        byte[] imageData=storeService.downloadImageFromFileSystem(filename);
        return ResponseEntity.status(HttpStatus.OK)
                .contentType(valueOf("image/png"))
                .body(imageData);
    }
}
