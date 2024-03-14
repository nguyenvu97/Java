package com.example.k4_flutter.Auth;

import com.example.k4_flutter.Config.JwtService;
import com.example.k4_flutter.Exception.login3time5mException;
import com.example.k4_flutter.SendEmail.EmailService;
import com.example.k4_flutter.Strore.Status;
import com.example.k4_flutter.Strore.Store;
import com.example.k4_flutter.Strore.StoreRepo;
import com.example.k4_flutter.Totp.TotpService;
import com.example.k4_flutter.User.Role;
import com.example.k4_flutter.User.Token.Token;
import com.example.k4_flutter.User.Token.TokenRepo;
import com.example.k4_flutter.User.Token.TokenType;
import com.example.k4_flutter.User.User;
import com.example.k4_flutter.User.UserRepo;
import com.example.k4_flutter.Wallet.Wallet;
import com.example.k4_flutter.Wallet.WalletRepo;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthenticationService {

    public final UserRepo userRepo;

    public final PasswordEncoder passwordEncoder;
    public final AuthenticationManager authenticationManager;
    public final TokenRepo tokenRepo;
    public  final JwtService jwtService;
    public  final StoreRepo storeRepo;
    public  final WalletRepo walletRepo;
    public final EmailService emailService;
    public final TotpService totpService;
    private Map<String, LoginInfo> loginInfoMap =  new HashMap<>();
    public AuthenticationResponse register (RegisterRequest request){
        GoogleAuthenticator gAuth = new GoogleAuthenticator();
        GoogleAuthenticatorKey key = gAuth.createCredentials();
        String keyinfo = totpService.hashSHA256(key.getKey()+request.getEmail());
        var user = userRepo.save(User
                .builder()
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .address(request.getAddress())
                .email(request.getEmail())
                .phone(request.getPhone())
                .fullName(request.getFullName())
                .privateKey(keyinfo)
                .build());
        var store = Store.builder().shopPhone(request.getPhone()).shopEmail(request.getEmail()).shopName(request.getFullName()).shopAddress(request.getAddress()).status(Status.DIE).storeMoney(0).build();
        var wallet = Wallet.builder().wallet(0).phoneNo(request.getPhone()).email(request.getEmail()).build();
        storeRepo.save(store);
        walletRepo.save(wallet);
//        String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Đăng ký thành công </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Đăng ký thành công</h1>\n" + "    <p>Cảm ơn bạn đã đăng ký thành công!</p>\n" + "    <p>Bạn có thể đăng nhập vào tài khoản của mình ngay bây giờ.</p>\n" + "</body>\n" + "</html>\n";
//        emailService.sendemail(request.getEmail(),request.getEmail(),body);
        var jwtToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse.builder().accessToken(jwtToken).refreshToken(refreshToken).build();

    }
    public AuthenticationResponse Login(AuthenticationRequest request,HttpServletResponse response) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        var user = userRepo.findByEmail(request.getEmail()).orElseThrow();
//        if (checkLogin3tAnd5M(request.getEmail())) {
            var jwtToken = jwtService.generateToken(user);
            var refreshToken = jwtService.generateRefreshToken(user);
            revokeAllUserTokens(user);
            saveUserToken(user, jwtToken);
            return AuthenticationResponse.builder().accessToken(jwtToken).refreshToken(refreshToken).build();
//        }
//        throw new login3time5mException("loi me roi");
    }
    private void saveUserToken(User user, String jwtToken) {
        var token = Token.builder().user(user).token(jwtToken).tokenType(TokenType.BEARER).expired(false).revoked(false).build();
        tokenRepo.save(token);
    }

    private void revokeAllUserTokens(User user) {
        var validUserTokens = tokenRepo.findAllValidTokenByUser(user.getId());
        if (validUserTokens.isEmpty()) return;
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepo.saveAll(validUserTokens);
    }


    public void refreshToken(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if (authHeader == null || !authHeader.startsWith("Bearer")) {
            return;
        }
        refreshToken = authHeader.substring(7);
        userEmail = jwtService.extracUsername(refreshToken);
        if (userEmail != null) {
            var user = this.userRepo.findByEmail(userEmail).orElseThrow();
            if (jwtService.isTokenValid(refreshToken, user)) {
                var accessToken = jwtService.generateToken(user);
                revokeAllUserTokens(user);
                saveUserToken(user, accessToken);
                var authResponse = AuthenticationResponse.builder().accessToken(accessToken).refreshToken(refreshToken).build();
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }
    public boolean checkLogin3tAnd5M(String username) {
        if (loginInfoMap.containsKey(username)) {
            LoginInfo info = loginInfoMap.get(username);
            if (info.getAttempts() >= 3){
                if (info.getLastAttempt().plusMinutes(5).isAfter(LocalDateTime.now())){
                    return false;
                }else {
                    info.setAttempts(0);
                }
            }
            info.setAttempts(info.getAttempts() + 1);
            info.setLastAttempt(LocalDateTime.now());
        } else {
            // Người dùng chưa đăng nhập lần nào, tạo thông tin đăng nhập mới
            loginInfoMap.put(username, new LoginInfo(1, LocalDateTime.now()));
        }

        // Đăng nhập thành công
        return true;
    }

}
