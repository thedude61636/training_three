import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_three/data/dio_repo.dart';
import 'package:training_three/data/model/post.dart';
import 'package:training_three/data/responses/posts_response.dart';
import 'package:training_three/main.dart';
import 'package:training_three/providers/login_state.dart';
import 'package:training_three/screens/add_post_screen.dart';
import 'package:training_three/screens/login_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  // this skips any issues you have with ssl
  // ssl should be fixed from your server
  // otherwise it's a security issue
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // this applies the overrides that skip issues with ssl
    HttpOverrides.global = MyHttpOverrides();

    postsFuture = fetchPost();
  }

  Future<List<Post>> postsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (Provider.of<LoginState>(context, listen: false).isLoggedIn)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPostScreen(),
                    ));
              else
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ));
            },
          ),
          if (Provider.of<LoginState>(context).isLoggedIn)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Provider.of<LoginState>(context, listen: false).token = "";
              },
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshPosts();
        },
        child: FutureBuilder<List<Post>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.none)
              return Container();

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var post = snapshot.data[index];

                return Card(
                  // margin: EdgeInsets.all(16),
                  elevation: 8,
                  child: ListTile(
                    title: Text(post.title ?? "No title"),
                    subtitle: Text(post.content ?? "No Content"),
                    leading: Icon(Icons.new_releases_sharp),
                    trailing: IconButton(
                      onPressed: () {
                        deletePost(post.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[400],
                      ),
                    ),
                  ),
                );
                // return Card(
                //   elevation: 8,
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Icon(Icons.new_releases_sharp),
                //               Text(
                //                 post.title ?? "No title",
                //                 style: TextStyle(
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               Text(post.content ?? "No content"),
                //             ],
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         icon: Icon(Icons.delete),
                //         onPressed: () {},
                //       )
                //     ],
                //   ),
                // );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Post>> fetchPost() async {
    // var dio = Dio();
    var dio = DioRepo.getDio();

    var response = await dio.get("posts");
    print(response.data.runtimeType);
    var postsResponse = PostsResponse.fromJson(response.data);
    print(postsResponse.posts[1].title);

    return postsResponse.posts;
  }

  Future deletePost(String id) async {
    try {
      var response = await DioRepo.getDio().delete("posts/" + id);
      refreshPosts();
    } catch (error) {
      if (error is DioError) {
        var message = error.response.data["error"];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

      print(error);
    }
  }

  void refreshPosts() {
    setState(() {
      postsFuture = fetchPost();
    });
  }
}
