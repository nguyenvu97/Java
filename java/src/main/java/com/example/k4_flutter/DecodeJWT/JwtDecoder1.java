package com.example.k4_flutter.DecodeJWT;

import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Strore.Status;
import com.example.k4_flutter.Strore.Store;
import com.example.k4_flutter.Strore.StoreRepo;
import com.example.k4_flutter.User.User;
import com.example.k4_flutter.User.UserRepo;
import com.example.k4_flutter.Wallet.Wallet;
import com.example.k4_flutter.Wallet.WalletRepo;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Base64;
import java.util.Optional;

@RequiredArgsConstructor
@RestController
@RequestMapping("api/v1/decode")
public class JwtDecoder1 {
    public final UserRepo userDao;
    public final StoreRepo storeDao;
    public final WalletRepo walletRepo;
    @GetMapping
    public MemberData decode(@RequestHeader("Authorization") String token) {
        String[] tokenParts = token.split("\\.");
        if (tokenParts.length == 3) {

            String payload = tokenParts[1];
            byte[] decodedPayload = Base64.getDecoder().decode(payload);
            try {
                ObjectMapper objectMapper = new ObjectMapper();
                MemberData memberData = objectMapper.readValue(decodedPayload, MemberData.class);
                Optional<User> foundMember = userDao.findByEmail(memberData.getSub());
                if (foundMember.isPresent()) {
                    User user = foundMember.get();
                    memberData.setId(user.getId());
                    memberData.setAddress(user.getAddress());
                    memberData.setPhone(user.getPhone());
                    Optional<Store> storeEntity = storeDao.findById(user.getId());
                    Wallet wallet = walletRepo.findById(user.getId()).orElseThrow(null);
                    if (storeEntity.isPresent() && wallet != null) {
                        memberData.setStoreId(storeEntity.get().getId());
                        memberData.setShopStatus(storeEntity.get().getStatus().toString());
                        memberData.setMoney(wallet.getWallet());
                    }
                    return memberData;
                }
            } catch (Exception e) {
                e.getMessage();
            }
        }
        return null;
    }
}
