package com.example.k4_flutter.Kafka;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.OrderDetails.OrderDetails;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Properties;

@Service
public class KafkaService {

    @Autowired
    public  KafkaTemplate<String, Object> kafkaTemplate;
    @Autowired
    public JwtDecoder1 jwtDecoder1;
    public final String topic = "kafka";
    public MemberData sendKafka(String token) {
        MemberData memberData = jwtDecoder1.decode(token);


          kafkaTemplate.send(topic, memberData);
        return memberData;
    }



}
