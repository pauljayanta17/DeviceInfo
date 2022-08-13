import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataDisplay extends StatefulWidget {
  static final String routeName = '/datadisplay';
  final String title;
  const DataDisplay({Key? key, required this.title}) : super(key: key);

  @override
  State<DataDisplay> createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  List<dynamic> _data = [];
  String description = '';
  String imageURL = '';
  Future<String> _loadData() async {
    final String response =
        await rootBundle.loadString('assets/android_data.json');
    final data = await jsonDecode(response);
    setState(() {
      _data = data['data'];
    });

    for (var element in _data) {
      if (element['title'] == widget.title) {
        setState(() {
          imageURL = element['image'];
          description = element['description'];
        });
      }
    }
    if (imageURL == '') {
      setState(() {
        imageURL = 'https://kbimages.dreamhosters.com/images/Site_Not_Found_Dreambot.fw.png';
        description = 'Nothing';
      });
    }

    return "success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 25, 25),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: FutureBuilder(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/loadingimage.jpg',
                      image: imageURL,
                      fit: BoxFit.cover,
                      height: size.height * 0.4,
                      width: double.infinity,
                      fadeInCurve: Curves.bounceOut,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text(
                      "Description : ",
                      style: TextStyle(
                          fontSize: size.height * 0.034,
                          color: Color.fromARGB(255, 245, 55, 55)),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: size.height * 0.026,
                          color: Color.fromARGB(255, 19, 148, 116)),
                      textAlign: TextAlign.justify,
                    )
                  ],
                );
              }
              if (snapshot.hasError) {
                return Text("Error");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
