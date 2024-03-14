package com.example.k4_flutter.Totp;

import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.User.User;
import com.example.k4_flutter.User.UserRepo;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class TotpService {
    public final UserRepo userRepo;
    public final TotpRepo totpRepo;
    public final PasswordEncoder passwordEncoder;
    public  String hashSHA256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));

            // Convert the byte array to hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    public boolean authenticateUser(String email) {
        User user = userRepo.findByEmail(email).orElseThrow(() -> new FindByNotID("not user in in db" + email));
        generateAndSaveOTP(user.getEmail());
        return true;
    }

    private int generateAndSaveOTP(String email) {
        User user = userRepo.findByEmail(email).orElseThrow(() -> new FindByNotID("not user in in db" + email));
        ZoneId zoneId = ZoneId.of("Asia/Ho_Chi_Minh");
        ZonedDateTime zonedDateTime = LocalDateTime.now().atZone(zoneId);
        long currentTimeMillis = zonedDateTime.toEpochSecond() * 1000;
        GoogleAuthenticator gAuth = new GoogleAuthenticator();
        int otp = gAuth.getTotpPassword(user.getPrivateKey(),currentTimeMillis);
        totpRepo.save(Totp
                .builder()
                        .createAt(LocalDateTime.now())
                        .exp(false)
                        .number(otp)
                        .email(email)
                .build());
        log.info("ma otp la " +otp);
        return otp;
    }
    public String verifyOTP(int otp,String password) {
        Totp totp = totpRepo.findByNumberAndExp(otp,false);
        if (totp == null) {
            throw new FindByNotID("OTP not found");
        }
        LocalDateTime createTotpTime = totp.getCreateAt();
        LocalDateTime currentTime = LocalDateTime.now();
        Duration duration = Duration.between(createTotpTime, currentTime);
        long minutesDifference = duration.toMinutes();

        if (CheckTime(minutesDifference)) {
            User user = userRepo.findByEmail(totp.getEmail()).orElseThrow(null);

            GoogleAuthenticator gAuth = new GoogleAuthenticator();
            boolean isValid = gAuth.authorize(user.getPrivateKey(), otp);
            if (isValid) {
                user.setPassword(passwordEncoder.encode(password));
                userRepo.save(user);
                totp.setExp(true);
                totpRepo.save(totp);
                return "change the password OK";
            }
        }
        totp.setExp(true);
        totpRepo.save(totp);
        throw  new RuntimeException("Expired otp code");
    }


    private boolean CheckTime(long time ) {
        return time <= 1;
    }
}
