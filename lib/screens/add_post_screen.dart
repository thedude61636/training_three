import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_three/data/dio_repo.dart';
import 'package:training_three/providers/login_state.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool isLoading = false;

  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Builder(
        builder: (context) {
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  if (isLoading) LinearProgressIndicator(),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: "Content"),
                  ),
                  FlatButton.icon(
                    label: Text("Submit"),
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendPost();
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future sendPost() async {
    setState(() {
      isLoading = true;
    });
    // var token = Provider.of<LoginState>(context, listen: false).token;
    // Dio dio = Dio(BaseOptions(baseUrl: "https://10.0.2.2:5001/api/v1/"));
    //
    // try {
    //   var response = await dio.post(
    //     'posts',
    //     data: {
    //       "title": _titleController.text,
    //       "content": _contentController.text
    //     },
    //     options: Options(headers: {"Authorization": "Bearer $token"}),
    //   );

    await Future.delayed(Duration(milliseconds: 500));

    Dio dio = DioRepo.getDio();

    try {
      var response = await dio.post(
        'posts',
        data: {
          "title": _titleController.text,
          "content": _contentController.text
        },
      );

      print(response);
      Navigator.pop(context);
    } catch (e) {
      print(e.runtimeType);

      if (e is DioError) {
        if (e.response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You are not authorized to post"),
          ));
        }
      }

      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      // ));
    }
    setState(() {
      isLoading = false;
    });
  }
}
