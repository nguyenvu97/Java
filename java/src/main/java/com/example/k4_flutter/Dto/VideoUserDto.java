package com.example.k4_flutter.Dto;

import com.example.k4_flutter.Product.Status;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@Builder
public class VideoUserDto {
    private int id;
    private String email;
    private String content;
    private int userId;
    private Status status;
    private String videoName;
    private String pathVideo;
    private String pathThumbnail;

}
