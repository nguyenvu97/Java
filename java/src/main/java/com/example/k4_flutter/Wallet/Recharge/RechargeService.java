package com.example.k4_flutter.Wallet.Recharge;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class RechargeService {
    @Autowired
    public RechargeRepo rechargeRepo;
    @Autowired
    public JwtDecoder1 jwtDecoder1;
    public List<Recharge> historyRechargeUser(String token){
        if (token == null){
            return null;
        }
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null){
            return null;
        }
        List<Recharge>rechargeList = rechargeRepo.findByWalletId(memberData.getId());
        if (rechargeList != null) {
            List<Recharge> filteredRechargeList = rechargeList.stream()
                    .filter(recharge -> recharge.getStatus() == RechargeStatus.OK)
                    .collect(Collectors.toList());
            return filteredRechargeList;
        }
        return null;
    }
}
