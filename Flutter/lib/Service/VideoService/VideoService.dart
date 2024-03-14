import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:thaidui/Service/VideoService/Video.dart';

class VideoService {
  final storage = FlutterSecureStorage();
  Future<void> addVideoUser(File file, String content) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    final request = await http.MultipartRequest(
        'post',
        Uri.parse(
            'http://localhost:9091/api/v1/video/encodeVideo?content=$content'));
    request.headers['Authorization'] = '$token';
    request.files.add(
      http.MultipartFile(
        'file',
        http.ByteStream(file.openRead()),
        await file.length(),
        filename: 'video.mp4', // Set the filename as needed
      ),
    );
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("loi he thong add Video $e");
    }
  }

  Future<List<Video>?> getAllVideo() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:9091/api/v1/video/getAllVideo'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Video> video = data.map((json) => Video.fromJson(json)).toList();
        print(video);
        return video;
      }
    } catch (e) {
      print("loi he thong getAllVideo $e");
    }
  }

  Future<File?> uploadVideo(String videoName) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:9091/api/v1/video/$videoName'));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$videoName.mp4');
        await file.writeAsBytes(bytes);
        return file; // Trả về tệp video đã tải xuống
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading video: $e");
    }
    // Trả về null nếu có lỗi
  }
}
