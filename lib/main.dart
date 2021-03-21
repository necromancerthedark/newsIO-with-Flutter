import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/UpperBar.dart';
import 'package:news_app/webPage.dart';
import 'news_api_data.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NewsIO",
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Future<News> newsData;
  WebViewController _controller;

  Future<News> fetchNews() async {
    final response = await http.get(
        "https://newsapi.org/v2/top-headlines?sources=google-news-in&apiKey=41777a69b62348faa1f6b3e831e14b3b");
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch");
    }
  }

  void createWebView(String url) {
    WebView(
      initialUrl: url,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
      },
    );
    _controller.loadUrl(url);
  }

  @override
  void initState() {
    super.initState();
    newsData = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Upperbar(),
      body: FutureBuilder<News>(
        future: newsData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.totalResults,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data.articles[index].urlToImage),
                    ),
                    title: Text(snapshot.data.articles[index].title),
                    contentPadding: EdgeInsets.all(15.0),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                webPage(snapshot.data.articles[index].url),
                          ),
                        );
                      });
                      //_launchURL(snapshot.data.articles[index].url);
                    },
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
