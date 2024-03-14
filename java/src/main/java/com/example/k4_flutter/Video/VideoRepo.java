package com.example.k4_flutter.Video;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VideoRepo  extends JpaRepository<Video,Integer> {
    Optional<Video> findByVideoName(String filename);
}
