// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../models/item.dart';
import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Xml2Json xml2json = Xml2Json();

  Map<String, dynamic> data = {};

  String source = 'https://conobie.jp/smartnews';

  List<Item> itemList = [];

  ///
  Future<void> getData() async {
    final response = await http.get(Uri.parse(source));

    final utf8decodedStr = utf8.decode(response.bodyBytes);

    xml2json.parse(utf8decodedStr);

    final jsonData = xml2json.toGData();

    setState(() {
      data = json.decode(jsonData);
    });
  }

  ///
  @override
  void initState() {
    super.initState();

    getData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [Expanded(child: _displayArticle())],
        ),
      ),
    );
  }

  ///
  Widget _displayArticle() {
    final list = <Widget>[];

    if (data.isNotEmpty) {
      for (var i = 0; i < data['rss']['channel']['item'].length; i++) {
        final onedata = data['rss']['channel']['item'][i];

        list.add(Container(
          width: double.infinity,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onedata['media\$thumbnail'] != null && onedata['media\$thumbnail']['\$t'] != null) ...[
                SizedBox(
                  width: 80,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no_image.png',
                    image: onedata['media\$thumbnail']['\$t'],
                  ),
                ),
              ],
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(onedata['title']['\$t']),
                    Text(onedata['link']['\$t']),
                    Text(onedata['guid']['\$t']),
                    Text(onedata['description']['\$t']),
                    Text(onedata['pubDate']['\$t']),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(
                        item: Item(
                          title: (onedata['title'] != null && onedata['title']['\$t'] != null)
                              ? onedata['title']['\$t']
                              : '',
                          link:
                              (onedata['link'] != null && onedata['link']['\$t'] != null) ? onedata['link']['\$t'] : '',
                          guid:
                              (onedata['guid'] != null && onedata['guid']['\$t'] != null) ? onedata['guid']['\$t'] : '',
                          description: (onedata['description'] != null && onedata['description']['\$t'] != null)
                              ? onedata['description']['\$t']
                              : '',
                          pubDate: (onedata['pubDate'] != null && onedata['pubDate']['\$t'] != null)
                              ? onedata['pubDate']['\$t']
                              : '',
                          content:
                              (onedata['content\$encoded'] != null && onedata['content\$encoded']['__cdata'] != null)
                                  ? onedata['content\$encoded']['__cdata']
                                  : '',
                          category: (onedata['category'] != null && onedata['category']['\$t'] != null)
                              ? onedata['category']['\$t']
                              : '',
                          dc: (onedata['dc\$creator'] != null && onedata['dc\$creator']['\$t'] != null)
                              ? onedata['dc\$creator']['\$t']
                              : '',
                          media: (onedata['media\$thumbnail'] != null && onedata['media\$thumbnail']['\$t'] != null)
                              ? onedata['media\$thumbnail']['\$t']
                              : '',
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
        ));
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
