package com.example.k4_flutter.Kafka;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/kafka")

public class KafkaController {
    @Autowired
    public  KafkaService kafkaService;

    @GetMapping()
    public ResponseEntity<?> testKafka(@RequestHeader("Authorization") String token){
        return ResponseEntity.ok().body(kafkaService.sendKafka(token));
    }
}
