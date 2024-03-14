package com.example.k4_flutter.Dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ResultDto {
    private String status;
    private String messger;
    private LocalDateTime date;
    private String url;
}
