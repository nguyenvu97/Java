import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:thaidui/Myshop/MyShop.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Service/VideoService/Video.dart';
import 'package:thaidui/Service/VideoService/VideoService.dart';
import 'package:video_player/video_player.dart';

class GetallVideo extends StatefulWidget {
  const GetallVideo({super.key});

  @override
  State<GetallVideo> createState() => _GetallVideoState();
}

List<Video> video = [];
PageController _pageController = PageController();

VideoService videoService = VideoService();
bool _isLoading = false;

class _GetallVideoState extends State<GetallVideo> {
  Future<void> _loadVideos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Thực hiện logic để tải danh sách video từ API hoặc cơ sở dữ liệu
    try {
      List<Video>? newVideos = await videoService.getAllVideo();
      if (newVideos != null && newVideos.isNotEmpty) {
        setState(() {
          video.addAll(newVideos);
        });
        return;
      }
    } catch (e) {
      print('Error loading videos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildVideo(context));
  }
}

Widget buildVideo(BuildContext context) {
  if (video.isEmpty) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Container(
            height: 50,
            width: 50,
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Video Not Data',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
  return PageView.builder(
    itemCount: video.length,
    controller: _pageController,
    itemBuilder: ((context, index) {
      return VideoPlayerWidget(
        videoName: video[index].videoName,
        content: video[index].content,
        email: video[index].email,
        userId: video[index].userId,
      );
    }),
  );
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoName;
  final String content;
  final String email;
  final int userId;

  VideoPlayerWidget(
      {Key? key,
      required this.videoName,
      required this.userId,
      required this.content,
      required this.email})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isControllerInitialized = false;
  bool _likeSelected = false;
  bool _dislikeSelected = false;

  Future<void> initializeVideoController() async {
    try {
      File? videoData = await VideoService().uploadVideo(widget.videoName);
      if (videoData != null) {
        _controller = VideoPlayerController.file(videoData);
        await _controller.initialize();
        setState(() {
          _isControllerInitialized = true;
        });
      } else {
        print("Không thể nhận dữ liệu video");
      }
    } catch (e) {
      print("Lỗi khi khởi tạo VideoPlayerController: $e");
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        linkUrl: 'http://localhost:9091/api/v1/video/${widget.videoName}',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _isControllerInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Container(
                  width: 430,
                  height: 932,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(left: 10, top: 40),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => homepage()));
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 600, left: 400),
                            height: 200,
                            child: rightIcon(),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 800, left: 30, bottom: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyShop(
                                                  id: widget.userId,
                                                )));
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              'https://funix.edu.vn/wp-content/uploads/2021/11/java-l%C3%A0-g%C3%AC.jpeg',
                                            ))),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 25),
                                        child: Text(
                                          widget.email,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(widget.content,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ]),
    );
  }

  Widget rightIcon() {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _likeSelected = true;
                _dislikeSelected = false;
              });
            },
            child: Image.asset(
              'asset/like.png',
              color: _likeSelected ? Colors.blue : Colors.white,
            ),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(
            top: 10,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _dislikeSelected = true;
                _likeSelected = false;
              });
            },
            child: Image.asset(
              'asset/dislike.png',
              width: 50,
              height: 50,
              color: _dislikeSelected ? Colors.blue : Colors.white,
            ),
          ),
        ),
        Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                share();
              },
              child: Icon(
                Icons.ios_share,
                color: Colors.white,
                size: 30,
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
