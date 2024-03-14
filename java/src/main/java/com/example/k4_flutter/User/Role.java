package com.example.k4_flutter.User;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Collections;
import java.util.List;

public enum Role {
    USER,ADMIN;
    public List<GrantedAuthority> getAuthorities(){
        SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + this.name());
        return Collections.singletonList(authority);
    }
}
