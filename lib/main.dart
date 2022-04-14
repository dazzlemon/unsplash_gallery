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
      title: 'Unsplash Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UnsplashGallery(),
    );
}

/// This class fetches the data from unsplash,
/// and passes it to Gallery, which is presentational component
class UnsplashGallery extends StatefulWidget {
  const UnsplashGallery({Key? key}) : super(key: key);

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

Widget networkImageLoadingBuilder(
	BuildContext context, Widget child, ImageChunkEvent? loadingProgress
) => loadingProgress == null
	? child
	: Center(
		child: CircularProgressIndicator(
			value: loadingProgress.expectedTotalBytes != null
				? loadingProgress.cumulativeBytesLoaded /
						loadingProgress.expectedTotalBytes!
				: null
		),
	);

class _UnsplashGalleryState extends State<UnsplashGallery> {
	String urlBase = "https://api.unsplash.com/photos/?client_id=";
	String urlId =
		"ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9";

	List data = [];

	getData() async {
		http.Response response = await http.get(Uri.parse(urlBase + urlId));
		data = json.decode(response.body);
	}

	@override
	void initState() {
		getData();
		super.initState();
	}

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: Center(
        child: FutureBuilder(
					future: http.get(Uri.parse(urlBase + urlId)),
					builder: (context, AsyncSnapshot<http.Response> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							json.decode(snapshot.data!.body);
							return GridView.count(
								crossAxisCount:
									(MediaQuery.of(context).size.width / 160).round(),
								children: data.map((imgData) =>
									GestureDetector(
										onTap: () => Navigator.push(context, MaterialPageRoute(
											builder: (context) => Image.network(
												imgData["urls"]["full"],
												loadingBuilder: networkImageLoadingBuilder
											)
										)),
										child: ThumbWithText(
											imgData["user"]["username"],
											Image.network(
												imgData["urls"]["thumb"],
												loadingBuilder: networkImageLoadingBuilder
											)
										)
									)
								).toList()
							);
						}
						return const CircularProgressIndicator();
					}
				),
				
      )
    );
}
