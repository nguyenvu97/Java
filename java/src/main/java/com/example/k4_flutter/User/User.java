package com.example.k4_flutter.User;

import com.example.k4_flutter.User.Token.Token;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
@Getter
@Setter
@Table(name = "customer")
public class User implements UserDetails {
    @Id
    @SequenceGenerator(name="user_ud_name",sequenceName = "user_ud_name")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    @Column( unique = true)
    private String email;
    private String password;
    private String fullName;
    private String address;
    @Column( unique = true)
    private String phone;
    @Enumerated(EnumType.STRING)
    private Role role;
    @OneToMany(mappedBy = "user")
    private List<Token> tokens;
    private String privateKey;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return role.getAuthorities();
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}