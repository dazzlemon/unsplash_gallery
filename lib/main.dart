import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() =>
  runApp(const UnsplashGalleryApp());

class UnsplashGalleryApp extends StatelessWidget {
  const UnsplashGalleryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UnsplashGallery(title: 'Flutter Demo Home Page'),
    );
}

/// This class fetches the data from unsplash,
/// and passes it to Gallery, which is presentational component
class UnsplashGallery extends StatefulWidget {
  const UnsplashGallery({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<UnsplashGallery> createState() => _UnsplashGalleryState();
}

class ThumbWithText extends StatelessWidget {
	final String text;
	final Image image;

  const ThumbWithText(this.text, this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    Container(
			decoration: BoxDecoration(
				border: Border.all(
					width: 0.5,
					color: Colors.grey,
				)
			),
			child: Column(
				children: <Widget>[
					Text(text),
					const SizedBox(height: 5),
					Container(
					margin: const EdgeInsets.only(left: 10, right: 10),
					child: const Divider(
						color: Colors.grey,
						height: 0.5,
					)),
					const SizedBox(height: 5),
					Expanded(
						child: image
					)
				],
			)
		);
}

/// This class shows list of image records,
/// when one of them is clicked, that image is shown fullscreen
// class Gallery

class _UnsplashGalleryState extends State<UnsplashGallery> {
	String urlBase = "https://api.unsplash.com/photos/?client_id=";
	String urlId =
		"ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9";

// -------------------------------------------------------------------------- //

   List data = [];
   bool flag1 = false;

	getData() async {
		http.Response response = await http.get(Uri.parse(urlBase + urlId));
		data = json.decode(response.body);
		setState(() => flag1 = true);
	}

	@override
	void initState() {
		getData();
		super.initState();
	}

// -------------------------------------------------------------------------- //

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: GridView.count(
          crossAxisCount: (MediaQuery.of(context).size.width / 160).round(),
          children: data.map((imgData) => ThumbWithText(
						imgData["user"]["username"],
						Image(image: NetworkImage(imgData["urls"]["thumb"]))
					)).toList()
        ),
      )
    );
}
