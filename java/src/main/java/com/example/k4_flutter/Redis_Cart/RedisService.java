package com.example.k4_flutter.Redis_Cart;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.OrderDetails.OrderDetails;
import com.example.k4_flutter.OrderDetails.OrderDetailsRepo;
import com.example.k4_flutter.OrderDetails.OrderStatus;
import com.example.k4_flutter.Product.Product;
import com.example.k4_flutter.Product.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
@Component
@Slf4j
public class RedisService {
    @Autowired
    private JwtDecoder1 jwtDecoder1;
    @Autowired
    public RedisTemplate redisTemplate;
    @Autowired
    public OrderDetailsRepo orderDetailsRepo;
    @Autowired
    public ProductService productService;


    public Cart SaveRedisCart(String token,int proudctId,int quantity) {
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null) {
            return null;
        }
        Product product = productService.GetById(proudctId);
        String key = "userID : " + memberData.getId();
        Cart cart = (Cart) redisTemplate.opsForHash().get(key, proudctId);
        if( cart == null){
            Cart cart1 = new Cart();
            cart1.setImg(product.getImg());
            cart1.setPrice(product.getPrice());
            cart1.setQuantity(quantity);
            cart1.setProductId(product.getId());
            cart1.setUserId(memberData.getStoreId());
            cart1.setStoreId(product.getStoreId());
            cart1.setProductName(product.getProductName());
            cart1.setPathImg(product.getPathImg());
            redisTemplate.opsForHash().put(key, proudctId, cart1);
            return cart1;
        }else if (cart.getProductId() == proudctId){
            int sumQuantity = cart.getQuantity() + quantity;
            cart.setQuantity(sumQuantity);
            redisTemplate.opsForHash().put(key, proudctId, cart);
            return cart;
        }
        return null;
    }

    public List<Cart> findByUserIdFromToken(String token) {
        MemberData memberData = jwtDecoder1.decode(token);

        // Kiểm tra xác thực JWT
        if (memberData == null) {
            log.error("Xác thực JWT không thành công");
            return Collections.emptyList(); // Hoặc trả về danh sách rỗng tùy thuộc vào logic của bạn
        }
        String key = "userID : " + memberData.getId();
        // Lấy dữ liệu từ Redis
        Collection<Object> hashValues = redisTemplate.opsForHash().values(key);

        // Kiểm tra xem có dữ liệu hay không
        if (hashValues == null) {
            log.warn("Không có dữ liệu trong Redis cho key: {}", key);
            return Collections.emptyList();
        }

        // Log số lượng phần tử trong Redis
        log.info("Số lượng phần tử trong Redis (key={}): {}", key, hashValues.size());

        // Lọc và trả về danh sách Cart dựa trên userId
        List<Cart> cartList = hashValues.stream()
                .filter(cart -> {
                    if (cart instanceof Cart) {
                        Integer userId = ((Cart) cart).getUserId();
                        return userId != null && userId.equals(memberData.getId());
                    }
                    return false;
                })
                .map(cart -> (Cart) cart)
                .collect(Collectors.toList());
        log.info(hashValues.toString());

        // Log số lượng phần tử trong danh sách Cart
        log.info("Số lượng phần tử trong danh sách Cart: {}", cartList.size());

        return cartList;
    }


    public String deleteProductInCart(List<Integer> productIdList, String token) {
        MemberData memberData = jwtDecoder1.decode(token);
        // Kiểm tra xác thực JWT
        if (memberData == null) {
            log.error("Xác thực JWT không thành công");
            return "delete failed - JWT authentication failed";
        }
        String key = "userID : " + memberData.getId();
        // Lấy dữ liệu từ Redis
        Collection<Object> hashValues = redisTemplate.opsForHash().values(key);

        // Kiểm tra xem có dữ liệu hay không
        if (hashValues == null) {
            log.info("Không có dữ liệu trong Redis cho key: {}", key);
            return "delete failed - Redis data not found";
        }

        // Log số lượng phần tử trong Redis
        log.info("Số lượng phần tử trong Redis (key={}): {}", key, hashValues.size());

        // Lọc danh sách Cart dựa trên userId
        List<Cart> cartList = hashValues.stream()
                .filter(cart -> {
                    if (cart instanceof Cart) {
                        Integer userId = ((Cart) cart).getUserId();
                        return userId != null && userId.equals(memberData.getId());
                    }
                    return false;
                })
                .map(cart -> (Cart) cart)
                .collect(Collectors.toList());

        // Tạo mảng hashKeys chứa productId của các phần tử cần xóa
        Object[] hashKeys = cartList.stream()
                .filter(cart -> productIdList.contains(cart.getProductId()))
                .map(cart -> cart.getProductId())
                .toArray();

        // Xóa các phần tử trong Redis dựa trên hashKeys
        redisTemplate.opsForHash().delete(key, hashKeys);

        // Log số lượng phần tử sau khi xóa
        log.info("Số lượng phần tử sau khi xóa sản phẩm: {}", hashValues.size());

        return "delete ok";
    }


    public Cart updateQuantityInCart(Integer productId, String token, int newQuantity){
        MemberData memberData = jwtDecoder1.decode(token);

        // Kiểm tra xác thực JWT
        if (memberData == null) {
            log.error("Xác thực JWT không thành công");
            return null;// Hoặc trả về danh sách rỗng tùy thuộc vào logic của bạn
        }
        String key = "userID : " + memberData.getId();
        // Lấy dữ liệu từ Redis
        Collection<Object> hashValues = redisTemplate.opsForHash().values(key);

        // Kiểm tra xem có dữ liệu hay không
        if (hashValues == null) {
            log.warn("Không có dữ liệu trong Redis cho key: {}", key);
            return null;
        }

        // Log số lượng phần tử trong Redis
        log.info("Số lượng phần tử trong Redis (key={}): {}", key, hashValues.size());
        List<Cart> cartList = hashValues.stream()
                .filter(cart -> {
                    if (cart instanceof Cart) {
                        Integer userId = ((Cart) cart).getUserId();
                        return userId != null && userId.equals(memberData.getId());
                    }
                    return false;
                })
                .map(cart -> (Cart) cart)
                .collect(Collectors.toList());
        log.info("Số lượng phần tử trong danh sách Cart: {}", cartList.size());
        Optional<Cart> cartToUpdate = cartList.stream()
                .filter(cart -> cart.getProductId().equals(productId))
                .findFirst();
        if (cartToUpdate.isPresent()){
            cartToUpdate.get().setQuantity(newQuantity);
            redisTemplate.opsForHash().put(key,productId,cartToUpdate.get());
            return cartToUpdate.get();
        }

        // Cập nhật số lượng nếu sản phẩm được tìm thấy
     return null;
    }
    public List<Cart>UpdatePrice(String token,List<Integer>productId) {
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null) {
            log.error("Xác thực JWT không thành công");
            return null;// Hoặc trả về danh sách rỗng tùy thuộc vào logic của bạn
        }
        String key = "userID : " + memberData.getId();
        // Lấy dữ liệu từ Redis
        Collection<Object> hashValues = redisTemplate.opsForHash().values(key);

        // Kiểm tra xem có dữ liệu hay không
        if (hashValues == null) {
            log.warn("Không có dữ liệu trong Redis cho key: {}", key);
            return null;
        }
        List<Cart> updatedCarts = new ArrayList<>();
        for (int product : productId) {
            Product product1 = productService.GetById(product);
            List<Cart> cartList = hashValues.stream()
                    .filter(cart -> {
                        if (cart instanceof Cart) {
                            Integer userId = ((Cart) cart).getUserId();
                            return userId != null && userId.equals(memberData.getId());
                        }
                        return false;
                    })
                    .map(cart -> (Cart) cart)
                    .collect(Collectors.toList());
            log.info("Số lượng phần tử trong danh sách Cart: {}", cartList.size());
            Optional<Cart> cartToUpdate = cartList.stream()
                    .filter(cart -> cart.getProductId().equals(productId))
                    .findFirst();
            if (cartToUpdate.isPresent()) {
                // Kiểm tra nếu giá mới khác giá cũ
                if (cartToUpdate.get().getPrice() != product1.getPrice()) {
                    cartToUpdate.get().setPrice(product1.getPrice());
                    redisTemplate.opsForHash().put(key, productId, cartToUpdate.get());
                    updatedCarts.add(cartToUpdate.get());
                }
            }
        }

        return updatedCarts;
    }
    @Async
    public CompletableFuture<List<Cart>> updatePriceAsync(String token, List<Integer> productIds) {
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null) {
            log.error("Xác thực JWT không thành công");
            return CompletableFuture.completedFuture(null);
        }
        String key = "userID : " + memberData.getId();
        // Lấy dữ liệu từ Redis
        Collection<Object> hashValues = redisTemplate.opsForHash().values(key);

        // Kiểm tra xem có dữ liệu hay không
        if (hashValues == null) {
            log.warn("Không có dữ liệu trong Redis cho key: {}", key);
            return CompletableFuture.completedFuture(null);
        }

            List<CompletableFuture<Cart>> updatedCarts = productIds.stream()
                    .map(productId -> updateCartItemAsync(productId, memberData.getId(), hashValues))
                    .collect(Collectors.toList());

        CompletableFuture<List<Cart>> combinedFuture = CompletableFuture.allOf(updatedCarts.toArray(new CompletableFuture[0]))
                .thenApply(v -> updatedCarts.stream()
                        .map(CompletableFuture::join)
                        .collect(Collectors.toList()));

        return combinedFuture;
    }

    private CompletableFuture<Cart> updateCartItemAsync(int productId, int userId, Collection<Object> hashValues) {
        Product product = productService.GetById(productId);
        List<Cart> cartList = hashValues.stream()
                .filter(cart -> cart instanceof Cart && ((Cart) cart).getUserId() != null && ((Cart) cart).getUserId().equals(userId))
                .map(cart -> (Cart) cart)
                .collect(Collectors.toList());
        String key = "userID : " + userId;
        log.info("Số lượng phần tử trong danh sách Cart: {}", cartList.size());

        Optional<Cart> cartToUpdate = cartList.stream()
                .filter(cart -> cart.getProductId().equals(productId))
                .findFirst();

        if (cartToUpdate.isPresent()) {
            cartToUpdate.get().setPrice(product.getPrice());
            if (cartToUpdate.get().getPrice() != (product.getPrice())) {
                redisTemplate.opsForHash().put(key, productId, cartToUpdate.get());
                return CompletableFuture.completedFuture(cartToUpdate.get());
            }
        }

        return CompletableFuture.completedFuture(null);
    }
}