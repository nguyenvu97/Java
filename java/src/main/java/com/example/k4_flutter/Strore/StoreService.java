package com.example.k4_flutter.Strore;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.Product.Product;
import com.example.k4_flutter.Product.ProductRepo;
import com.example.k4_flutter.User.UserRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class StoreService {
    public final StoreRepo storeDao;
    public final UserRepo userRepo;
    public final JwtDecoder1 jwtDecoder1;
    public final ProductRepo productRepo;
    @Value("${uploading.videoSaveFolder}")
    private String FOLDER_PATH;


    /*
    * off Store
    * */
    public String OffStore(String token ){
        MemberData memberData = jwtDecoder1.decode(token);
        Store store = storeDao.findById(memberData.getStoreId()).orElseThrow(()->new FindByNotID("Can not find by " + memberData.getStoreId()));
        store.setStatus(Status.DIE);

        storeDao.save(store);
        return "delete Shop ";
    }
    /*
     * create Store
     * */
    public Store CreateStore(String token) {
        MemberData memberData = jwtDecoder1.decode(token);
        Store store = storeDao.findByShopEmail(memberData.getSub()).orElseThrow(()->new FindByNotID( "can not create Shop"));
        store.setStatus(Status.LIVE);
        storeDao.save(store);
        return store;
    }
    /*
    take product for store
    * */
    public List<Product>findByProductIdForStore(String token ){
        MemberData memberData = jwtDecoder1.decode(token);
        Store store = storeDao.findById(memberData.getStoreId()).orElseThrow(()-> new FindByNotID("can not find StoreId" + memberData.getStoreId()));
        List<Product>products = productRepo.findByStoreId(store.getId());
        return  products;
    }
    /*
    payment Shop
    * */
    public String paymentShop(String token, double money) {
        // Sử dụng guard clauses cho kiểm tra
        if (money < 0 && token == null) {
            return null;
        }

        // Sử dụng Optional để tránh kiểm tra null
        MemberData memberData = jwtDecoder1.decode(token);
        Store store = storeDao.findById(memberData.getStoreId())
                .orElseThrow(() -> new FindByNotID("Không thể tìm thấy StoreId" + memberData.getStoreId()));

        double remainingBalance = store.getStoreMoney() - money;

        if (remainingBalance < 0) {
            throw new RuntimeException("money of account not full ");
        }

        store.setStoreMoney(remainingBalance);
        storeDao.save(store);
        String result = "Thanh toán số tiền: " + money;
        return result;
    }
    /*
    top 3 new Product in store
    * */
    public List<Product>getTop3ProductInShop(String token ){
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            throw new FindByNotID("not find by storeId");
        }
        List<Product> listProduct = productRepo.findTop4ByAndStoreIdOrderByIdDesc(PageRequest.of(0, 4),memberData.getStoreId());
        return listProduct;
    }

    public List<Product> getCategoryStoreId(String token,String category ){
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null && category == null){
            throw new FindByNotID("not find by storeId");
        }
        List<Product> listProduct = productRepo.findByStoreId(memberData.getStoreId());
        List<Product>countCategory = listProduct.stream().filter(product -> product.getCategory().equals(category)).collect(Collectors.toList());

        return countCategory;
    }
    /*
    store info
    * */
    public Store storeInfo(String token){
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            throw new FindByNotID("not find by storeId");
        }
        Store store = storeDao.findById(memberData.getStoreId()).orElseThrow(()->new FindByNotID("find By not store"));
        return  store;
    }
   /*
   update Store
   * */
   public Store updateStore(String token, Store store, MultipartFile file) throws IOException {
       MemberData memberData = jwtDecoder1.decode(token);
       if (memberData == null && file.isEmpty()) {
           throw new FindByNotID("not find by storeId");
       }
       String randomImageName = LocalDateTime.now().toString();

       // Use the random string as the filename
       String pathImg = FOLDER_PATH + "/" + randomImageName;
       file.transferTo(new File(pathImg));
       return   storeDao.findById(memberData.getStoreId()).map(existingStore -> {
           // Use if-else if statements for individual attribute updates
           if(existingStore.getStatus() == Status.LIVE) {
               if (store.getShopName() != null) {
                   existingStore.setShopName(store.getShopName());
               }
               if (store.getShopAddress() != null) {
                   existingStore.setShopAddress(store.getShopAddress());
               }
               if (store.getImage() != null) {
                   existingStore.setImage(store.getImage());
               }
               if (store.getShopPhone() != null) {
                   existingStore.setShopPhone(store.getShopPhone());
               }
               existingStore.setPathImage(pathImg);
               existingStore.setImage(randomImageName);

               return storeDao.save(existingStore);
           }
           return null;
       }).orElseGet(() -> storeDao.save(store));
   }

   /*
   update Image store
   * */
    public String updateImage(String token,MultipartFile file){
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null && file.isEmpty()) {
            throw new FindByNotID("not find by storeId");
        }

        String randomImageName = LocalDateTime.now().toString();

        // Use the random string as the filename
        String pathImg = FOLDER_PATH + "/" + randomImageName;
        try {
            file.transferTo(new File(pathImg));
            Store store = storeDao.findById(memberData.getStoreId()).orElseThrow(()-> new FindByNotID("find by not store"));
            if (store.getStatus() == Status.LIVE) {
                store.setImage(randomImageName);
                store.setPathImage(pathImg);
                storeDao.save(store);
                return "thanh cong";
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
      throw  new RuntimeException("create Shop");
    }
    public byte[] downloadImageFromFileSystem(String filename) throws IOException {
        Optional<Store> store = storeDao.findByImage(filename);
        String filePath = store.get().getPathImage();
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }


}
