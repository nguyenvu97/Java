package com.example.k4_flutter.Video;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;


@Slf4j
@RestController
@RequiredArgsConstructor
    @RequestMapping("/api/v1/video")
public class FFmpegController {
    private final VideoService videoService;
    @Value("${uploading.videoSaveFolder1}")
    private String FOLDER_PATH;
    public final JwtDecoder1 jwtDecoder1;
    public final  VideoRepo videoRepo;

    @PostMapping("/encodeVideo")
    public ResponseEntity<?> encodeVideo(@RequestParam("file") MultipartFile file,@RequestHeader("Authorization") String token,@RequestParam String content) {
       return ResponseEntity.ok().body(videoService.encodeVideo(file,token,content));
    }
    @GetMapping("/{videoName}")
    public ResponseEntity<?> getVideo(@PathVariable String videoName) {
        Video video = videoRepo.findByVideoName(videoName).orElse(null);
        if (video == null || !new File(video.getPathVideo()).exists()) {
            return ResponseEntity.notFound().build();
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("video/mp4"));

        try {
            Resource videoResource = new FileSystemResource(video.getPathThumbnail());
            long contentLength = videoResource.contentLength();

            InputStreamResource videoStream = new InputStreamResource(videoResource.getInputStream());

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(contentLength)
                    .body(videoStream);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    @GetMapping("/getAllVideo")
    public ResponseEntity<?>getAllVideo(){
        return ResponseEntity.ok().body(videoService.getAllVideoStatusIn1());
    }
    @GetMapping()
    public ResponseEntity<?> getVideo1() {
        String pathAudio = "/Users/khacvu/IdeaProjects/k4_flutter/src/main/resources/static/abcd.mp4";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("video/mp4"));

        try {
            Resource videoResource = new FileSystemResource(pathAudio);
            long contentLength = videoResource.contentLength();

            InputStreamResource videoStream = new InputStreamResource(videoResource.getInputStream());

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(contentLength)
                    .body(videoStream);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
