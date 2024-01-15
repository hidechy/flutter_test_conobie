import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/item.dart';

// ignore: must_be_immutable
class SecondScreen extends StatelessWidget {
  SecondScreen({super.key, required this.item});

  final Item item;

  late WebViewController webViewController;

  ///
  @override
  Widget build(BuildContext context) {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.dataFromString(
          item.content,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title),
            Text(item.link),
            Text(item.guid),
            Text(item.description),
            Text(item.pubDate),
            Text(item.category),
            Text(item.dc),
            Text(item.media),
            Divider(thickness: 5, color: Colors.indigo.withOpacity(0.4)),
            Expanded(child: WebViewWidget(controller: webViewController)),
          ],
        ),
      ),
    );
  }
}
