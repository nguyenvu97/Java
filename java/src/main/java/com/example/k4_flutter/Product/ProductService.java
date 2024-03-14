package com.example.k4_flutter.Product;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.Strore.Store;
import com.example.k4_flutter.Strore.StoreRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductService {

    public final StoreRepo storeRepo;
    public final ProductRepo productRepo;
    @Value("${uploading.videoSaveFolder}")
    private String FOLDER_PATH;
    public final JwtDecoder1 jwtDecoder1;

    /*
    store page
    * */
    public String saveProduct(String token, Product product, MultipartFile file) throws IOException {
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData.getStoreId() != null && file != null && !file.isEmpty()) {
            Optional<Store> store = storeRepo.findById(memberData.getStoreId());
            if (store.get().getStatus() == com.example.k4_flutter.Strore.Status.DIE) {
                throw new RuntimeException("You not Open Shop");
            }
            // Generate a random string for the image name using UUID
            String randomImageName = UUID.randomUUID().toString();

            // Use the random string as the filename
            String pathImg = FOLDER_PATH + "/" + randomImageName;
            file.transferTo(new File(pathImg));

            if (store.isPresent()) {
                 productRepo.save(
                        Product.builder()
                                .storeId(memberData.getStoreId())
                                .createAt(LocalDateTime.now())
                                .category(product.getCategory())
                                .status(Status.IN)
                                .price(product.getPrice())
                                .updateAt(LocalDateTime.now())
                                .productName(product.getProductName())
                                .quantity(product.getQuantity())
                                .img(randomImageName)
                                .pathImg(pathImg)
                                .build());
                return "save ok";
            }
        }
        return null;
    }
    public Product updateProduct(Product product, Integer id, String token) {
        MemberData memberData = jwtDecoder1.decode(token);

        if (memberData == null && product == null && id < 0) {
            return null;
        }
        Optional<Store> store = storeRepo.findById(memberData.getStoreId());
        if (store.isEmpty()) {
            throw new RuntimeException("Store not found");
        }
        Store currentStore = store.get();

        if (currentStore.getStatus() == com.example.k4_flutter.Strore.Status.DIE) {
            throw new RuntimeException("You cannot update products in a closed shop");
        }

        return productRepo.findById(id).map(
                existingProduct -> {
                    if (product.getProductName() != null) {
                        existingProduct.setProductName(product.getProductName());
                    }

                    if (product.getPrice() > 0) {
                        existingProduct.setPrice(product.getPrice());
                    }

                    if (product.getQuantity() > 0 && product.getQuantity() <= 1000) {
                        existingProduct.setQuantity(product.getQuantity());
                    }

                    if (product.getImg() != null) {
                        existingProduct.setImg(product.getImg());
                    }

                    if (product.getPathImg() != null) {
                        existingProduct.setPathImg(product.getPathImg());
                    }

                    existingProduct.setUpdateAt(LocalDateTime.now());
                    return productRepo.save(existingProduct);
                }).orElseGet(() -> productRepo.save(product));
    }

    /*
    * home page
    * */
    public List<Product> getAllProduct(){
        return productRepo.findAll();
    }
    public Product GetById(int productId) {
        if (productId <=0){
            return null;
        }
       Product product = productRepo.findById(productId).orElseThrow(() ->new FindByNotID("find by account" + productId));
        return product;
    }
    public List<Product> searchProduct(String keyword) {
        if (keyword == null){
            return null;
        }
        List<Product> searchResults = productRepo.findByProductNameContaining(keyword);
        return searchResults;
    }

    /*
    api Read forder Image
    * */
    public byte[] downloadImageFromFileSystem(String filename) throws IOException {
        Optional<Product> product = productRepo.findByImg(filename);
        String filePath = product.get().getPathImg();
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }

}
