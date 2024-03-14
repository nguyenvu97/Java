package com.example.k4_flutter.Product;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

import static org.springframework.http.MediaType.valueOf;

@RestController
@RequestMapping("api/v1/product")
public class ProductController {
    @Autowired
    public ProductService productService;

    /*
    save Product
    * */
    @PostMapping(value = {"/save"}, consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> addProduct(@RequestParam("product") String productJson,
                                        @RequestParam(required = false,value = "image") MultipartFile image,
                                        @RequestHeader("Authorization") String token
    ) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Product product = objectMapper.readValue(productJson, Product.class);
            return ResponseEntity.status(HttpStatus.OK).body(productService.saveProduct(token,product,image));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("null");
        }
    }
    /*

    update Product
    * */
    @PutMapping("store/{productID}")
    public ResponseEntity<Product> updateProduct(@PathVariable Integer productID, @RequestBody Product product,@RequestHeader("Authorization") String token) {
        Product updatedProduct = productService.updateProduct( product,productID,token);
        if (updatedProduct != null) {
            return ResponseEntity.ok(updatedProduct);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }
     /*

       Get All Product for HomePage

    * */
    @GetMapping("/GetallProduct")
    public ResponseEntity<?> GetAllProduct(){
        return ResponseEntity.ok(productService.getAllProduct());
    }
     /*

       Get by  ProductId for ProductDetails

    * */
    @GetMapping("GetByProductId/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable int id){
        return ResponseEntity.ok(productService.GetById(id));
    }
    /*

      sreach product

   * */
    @GetMapping("/sreachProduct")
    public ResponseEntity<?>sreachProduct(@RequestParam String keyword){
        return ResponseEntity.ok(productService.searchProduct(keyword));

    }
    /*

    api readFiles Image
    * */
    @GetMapping("/fileSystem/{filename}")// upload web
    public ResponseEntity<?> downloadImageFromFileSystem(@PathVariable String filename) throws IOException {
        byte[] imageData=productService.downloadImageFromFileSystem(filename);
        return ResponseEntity.status(HttpStatus.OK)
                .contentType(valueOf("image/png"))
                .body(imageData);
    }

}
