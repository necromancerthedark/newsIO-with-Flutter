import 'dart:async';
import "package:url_launcher/url_launcher.dart";
import 'package:flutter/material.dart';
import 'package:news_app/UpperBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webPage extends StatefulWidget {
  String newsUrl;
  webPage(this.newsUrl);
  @override
  _webPageState createState() => _webPageState();
}

class _webPageState extends State<webPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _goToBrowser() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                var url = widget.newsUrl;
                _launchURL(url);
              },
              child: Icon(
                Icons.open_in_browser_rounded,
                color: Colors.black54,
              ),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Upperbar(),
      body: WebView(
        initialUrl: widget.newsUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      floatingActionButton: _goToBrowser(),
    );
  }
}
