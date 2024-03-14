package com.example.k4_flutter.Auth;

import com.example.k4_flutter.User.Token.TokenRepo;
import com.example.k4_flutter.User.UserRepo;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class LogOutService implements LogoutHandler {
    @Autowired
    public TokenRepo tokenRepo;


    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        final  String authHeader = request.getHeader("Authorization");
        final String jwt;
        if (authHeader == null && !authHeader.startsWith("Bearer ")){
            return;
        }
        jwt = authHeader.substring(7);
        var storedToken = tokenRepo.findByToken(jwt).orElse(null);
        if (storedToken != null){
            storedToken.setExpired(true);
            storedToken.setRevoked(true);
            tokenRepo.save(storedToken);
            SecurityContextHolder.clearContext();
        }
    }
}
