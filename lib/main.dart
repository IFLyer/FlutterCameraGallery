import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_gallery/page/camera_page.dart';
import 'package:camera_gallery/page/preview_page.dart';
import 'package:camera_gallery/provider/gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  Future<void> _prepareCamera(
      BuildContext context, GalleryProvider galleryProvider) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    final str = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => CameraPage(
              camera: firstCamera,
            )));
    if (str != null) {
      print("ini str " + str);
      galleryProvider.addList(str);
    } else {
      print("kosong");
    }
  }

  _masterDialog(BuildContext context, GalleryProvider galleryProvider) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Add image from: '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _prepareCamera(context, galleryProvider);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => ViewFlowMeterPage()));
                },
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => ViewKwhMeterPage()));
                },
                child: const Text('Gallery'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GalleryProvider>(
      create: (_) => GalleryProvider(),
      child: Scaffold(
        floatingActionButton: Consumer<GalleryProvider>(
          builder: (context, galleryProvider, _) => FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _masterDialog(context, galleryProvider);
            },
          ),
        ),
        appBar: AppBar(
          title: Text("Camera Gallery App"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<GalleryProvider>(
            builder: (context, galleryProvider, _) => GridView.builder(
                itemCount: galleryProvider.list.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => PreviewPage(
                                imagePath: galleryProvider.list[index])));
                      },
                      child: Hero(
                        tag: galleryProvider.list[index],
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: new Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: new FileImage(
                                  File(galleryProvider.list[index]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
