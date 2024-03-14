import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Service/VideoService/VideoService.dart';

class AddVideoUser extends StatefulWidget {
  const AddVideoUser({super.key});

  @override
  State<AddVideoUser> createState() => _AddState();
}

class _AddState extends State<AddVideoUser> {
  TextEditingController _contentController = TextEditingController();
  File? files;
  final ImagePicker _picker = ImagePicker();
  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pick Video'),
              content: Text('Please check your Video '),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
    setState(() {
      files = File(file.path);
    });
  }

  VideoService videoService = VideoService();

  Future<void> inputVideo() async {
    try {
      await videoService.addVideoUser(files!, _contentController.text.trim());
      print('Video uploaded successfully'); // In thông báo khi thành công
    } catch (e) {
      print('Failed to upload video. Error: $e'); // In thông báo khi thất bại
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Video',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: Container(
            height: 50,
            width: 50,
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profiles()));
                },
                icon: Icon(Icons.arrow_back_ios)),
          )),
      body: Column(children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/flat-blue-design-image-upload-landing-pages_23-2148274066.jpg'))),
        ),
        Container(
          height: 50,
          width: 200,
          margin: EdgeInsets.only(left: 100, right: 100, top: 20),
          child: TextField(
            controller: _contentController,
            decoration: InputDecoration(
                labelText: "content",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.teal),
                )),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: _pickVideo,
            child: const Text("Pick Video From Gallery"),
          ),
        ),
        Container(
          height: 50,
          width: 300,
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              color: Colors.red),
          child: TextButton(
            onPressed: () {
              inputVideo();
            },
            child: Text(
              'upload Video',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}
