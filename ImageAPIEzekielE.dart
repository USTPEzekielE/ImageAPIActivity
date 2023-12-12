import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: false,
      ).copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<dynamic> photos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  getPhotos() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('https://pixabay.com/api/?key=41210248-bf63deb3d2af4981ad5010425&per_page=30'); 

    var response = await http.get(url);

    setState(() {
      isLoading = false;
      var data = json.decode(response.body);
      if (data['hits'] != null) {
        photos = data['hits'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Gallery"),
        backgroundColor: Colors.lightGreen,
      ),
      body: (isLoading)
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePage(
                          imageUrl: photos[index]["webformatURL"],
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Image.network(
                      photos[index]["webformatURL"],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final String imageUrl;

  ImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Detail"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
