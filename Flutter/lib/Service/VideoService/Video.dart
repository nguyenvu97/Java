class Video {
  int id;
  int userId;
  String content;
  String videoName;
  String pathVideo;
  String pathThumbnail;
  String email;

  Video({
    required this.id,
    required this.userId,
    required this.content,
    required this.videoName,
    required this.pathVideo,
    required this.pathThumbnail,
    required this.email,
  });

  // Convert the object to a readable string
  @override
  String toString() {
    return 'Video{id: $id, userId: $userId, content: $content,videoName: $videoName, pathVideo: $pathVideo, '
        'pathThumbnail: $pathThumbnail},email:$email';
  }

  // Convert the object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content, // Convert Status enum to string
      'videoName': videoName,
      'pathVideo': pathVideo,
      'pathThumbnail': pathThumbnail,
      'email': email,
    };
  }

  // Convert the object to a JSON format for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'videoName': videoName,
      'pathVideo': pathVideo,
      'pathThumbnail': pathThumbnail,
      'email': email,
    };
  }

  // Factory method to create a Video object from JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
        id: json['id'],
        userId: json['userId'],
        content: json['content'],
        videoName: json['videoName'],
        pathVideo: json['pathVideo'],
        pathThumbnail: json['pathThumbnail'],
        email: json['email']);
  }
}
