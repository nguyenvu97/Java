package com.example.k4_flutter.SendEmail;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class EmailService  implements EmailSender{

    private final JavaMailSender mailSender;

    @Override
    public void sendemail(String to, String email, String body) {
        try{
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage,true,"utf-8");
            mimeMessageHelper.setTo(to);
            mimeMessageHelper.setText(email,true);
            mimeMessageHelper.setFrom("nguyenkhacvu1997@gmail.com");
            mimeMessageHelper.setSubject("thanh cong");
            mimeMessageHelper.setText(body,true);
            mailSender.send(mimeMessage);
        }catch (Exception e){
            log.error(e.getMessage());
            throw new IllegalStateException("failed to send email");
        }
    }
}
