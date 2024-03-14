package com.example.k4_flutter.Video;

import com.example.k4_flutter.DecodeJWT.JwtDecoder1;
import com.example.k4_flutter.Dto.MemberData;
import com.example.k4_flutter.Dto.VideoUserDto;
import com.example.k4_flutter.Exception.FindByNotID;
import com.example.k4_flutter.Product.Status;
import com.example.k4_flutter.User.User;
import com.example.k4_flutter.User.UserRepo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.ffmpeg.global.avutil;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class VideoService {
    private final UserRepo userRepo;
    public final VideoRepo videoRepo;
    @Value("${uploading.videoSaveFolder1}")
    private String FOLDER_PATH;
    public final JwtDecoder1 jwtDecoder1;

    public String encodeVideo(MultipartFile file, String token, String content) {
        if (file.isEmpty()) {
            return "File is empty!";
        }
        MemberData memberData = jwtDecoder1.decode(token);
        if (memberData == null) {
            throw new FindByNotID("find By not id");
        }
        String videoName = UUID.randomUUID().toString();
        String pathVideo = FOLDER_PATH + "/" + videoName;
        String pathThumbnail = FOLDER_PATH + "/" + videoName + ".mp4";
        try {
            file.transferTo(new File(pathVideo));
//            String inputVideoFile = pathVideo;
//            String outputVideoFile = pathThumbnail;
            int desiredWidth = 430;
            int desiredHeight = 942;
            FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(pathVideo);
            FFmpegFrameRecorder recorder = new FFmpegFrameRecorder(pathThumbnail, desiredWidth, desiredHeight);//1
            log.info(String.valueOf(recorder));
            grabber.start();
            recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264); // chuan nen video
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC); // chuan nen am thanh
            recorder.setFormat("mp4");
            recorder.setPixelFormat(avutil.AV_PIX_FMT_YUV420P); // hien thi hinh anh mo giay
            recorder.setFrameRate(grabber.getFrameRate());  // fps
            recorder.setSampleRate(grabber.getSampleRate());
            recorder.setAudioChannels(grabber.getAudioChannels());
            recorder.setVideoQuality(0);
            recorder.setVideoBitrate(10_000);
            recorder.start();
            Frame capturedFrame;
            while (true) {
                capturedFrame = grabber.grab();
                if (capturedFrame == null) {
                    break; // Kết thúc vòng lặp nếu không còn frame
                }
                recorder.record(capturedFrame);
            }

            log.info("Video encoded successfully! Output file: {}", pathThumbnail);
            recorder.stop();
            recorder.release();
            grabber.stop();
            videoRepo.save(Video
                    .builder()
                    .status(Status.IN)
                    .videoName(videoName)
                    .pathVideo(pathVideo)
                    .pathThumbnail(pathThumbnail)
                    .userId(memberData.getId())
                    .content(content)
                    .build());
            return "Video encoded successfully!";
        } catch (IOException e) {
            log.error("Error encoding video!", e);
            return "Error encoding video!";
        }

    }

    public List<VideoUserDto> getAllVideoStatusIn1() {
        return videoRepo.findAll().stream().map(
                video -> {
                    User user = userRepo.findById(video.getUserId()).orElse(null);
                    return new VideoUserDto(video.getId(), user.getEmail(), video.getContent(), user.getId(), video.getStatus(), video.getVideoName(), video.getPathVideo(), video.getPathThumbnail());
                }
        ).collect(Collectors.toList());
    }

}


