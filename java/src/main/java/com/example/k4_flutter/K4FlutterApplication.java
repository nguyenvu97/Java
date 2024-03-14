package com.example.k4_flutter;


import lombok.extern.slf4j.Slf4j;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toList;


@SpringBootApplication
@Slf4j
public class K4FlutterApplication {

    public static void main(String[] args) {
        SpringApplication.run(K4FlutterApplication.class, args);
        String pathVideo = "/Users/khacvu/IdeaProjects/k4_flutter/src/main/resources/static/abc.mp4";
        String pathAudio = "/Users/khacvu/IdeaProjects/k4_flutter/src/main/resources/static/abcd.mp4";
        int desiredWidth = 430;
        int desiredHeight = 942;
        try {
            FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(pathVideo);
            FFmpegFrameRecorder recorder = new FFmpegFrameRecorder(pathAudio, desiredWidth,desiredHeight); // 0 là chọn âm thanh

            grabber.start();
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            recorder.setAudioChannels(grabber.getAudioChannels());
            recorder.setSampleRate(grabber.getSampleRate());
            recorder.start();
            recorder.setFormat("mp4a");

            Frame capturedFrame;
            while (true) {
                capturedFrame = grabber.grab();
                if (capturedFrame == null) {
                    break; // Kết thúc vòng lặp nếu không còn frame âm thanh
                }
                recorder.record(capturedFrame);
            }

            grabber.stop();
            recorder.stop();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}



