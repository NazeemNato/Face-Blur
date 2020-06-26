import 'package:face_blur/widget/show_loading.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTrue = true;
  bool imReady = true;
  bool imPicker = true;
  File file;
  String _url;
  String post = '';
  Dio dio = new Dio();
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File selected = File(pickedFile.path);
    if (selected != null) {
      setState(() {
        file = selected;
        isTrue = !isTrue;
        imPicker = !imPicker;
      });
    }
  }
  Future<void> _downloadPhoto(BuildContext context) async{
    if(_url.isNotEmpty){
      showLoading(context); 
      try{
        var timeKey = new DateTime.now().millisecondsSinceEpoch;
        String fileName = '$timeKey.jpg';
        var dirTosSave = await getApplicationDocumentsDirectory();
        await dio.download(_url, '${dirTosSave.path}/$fileName');
        Navigator.pop(context);
        Toast.show('Download Successfully', context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }catch(e){
        Navigator.pop(context);
        print('$e');
        Toast.show('Error', context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }
  }
  Future<void> _processFile(BuildContext context) async {
    if (imReady) {
      showLoading(context);
      try {
        var timeKey = new DateTime.now().millisecondsSinceEpoch;
        String fileName = '$timeKey.jpg';
        print('$fileName');
        final sendFile =
            await MultipartFile.fromFile(file.path, filename: fileName);
        final formData = FormData.fromMap({'file': sendFile});
        var res = await dio.post(
          '$post/file',
          data: formData,
        );
        var resBody = res.data;
        print('$resBody');
        setState(() {
          _url = '$post${resBody['blur']}';
          imReady = !imReady;
        });
        Navigator.pop(context);
      } catch (e) {
        Navigator.pop(context);
        print('$e');
        Toast.show('Error', context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Face Blur',
          style: GoogleFonts.oswald(
            color: Colors.black87,
            fontSize: 30
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isTrue
          ? noImage()
          : Container(
              child: Center(
                child: SingleChildScrollView(
                  child: imReady
                      ? Container(child: Image.file(file, fit: BoxFit.fill))
                      : Container(child: Image.network(_url, fit: BoxFit.fill)),
                ),
              ),
            ),
      floatingActionButton: imPicker
          ? FloatingActionButton(
              onPressed: _pickImage,
              child: Icon(Icons.photo),
              tooltip: 'Pick Image',
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () => _processFile(context),
                  child: imReady ? Icon(Icons.cloud_upload) : Icon(Icons.done),
                  tooltip: 'Process the Image',
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    _downloadPhoto(context);
                  },
                  child: Icon(Icons.cloud_download),
                  tooltip: 'Download',
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isTrue = !isTrue;
                      imPicker = !imPicker;
                      if (_url.isNotEmpty) {
                        imReady = !imReady;
                      }
                    });
                  },
                  child: Icon(Icons.delete),
                  tooltip: 'Pick Image',
                ),
                
              ],
            ),
    );
  }

  Widget noImage() {
    return Container(
      child: Center(
        child: Text(
          'Select Image',
          style: GoogleFonts.oswald(fontSize: 30),
        ),
      ),
    );
  }
}
