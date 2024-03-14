package com.example.k4_flutter.Video;

import com.example.k4_flutter.Product.Status;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Builder
public class Video {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int id;
    private int userId;
    private String content;
    private Status status;
    private String videoName;
    private String pathVideo;
    private String pathThumbnail;
}
