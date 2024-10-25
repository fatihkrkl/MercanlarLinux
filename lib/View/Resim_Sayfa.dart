import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Foto_Duzenleme.dart';

class ResimSayfa extends StatefulWidget {
  bool imza;// 1 ise imza / 0 ise resim
  ResimSayfa({required this.imza});
  CameraDescription firstCamera=const CameraDescription(
  name: "name",
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 10,
  );

  @override
  _ResimSayfaState createState() => _ResimSayfaState();
}

class _ResimSayfaState extends State<ResimSayfa> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void initState() {
    super.initState();
    _controller = CameraController(
      widget.firstCamera,
      ResolutionPreset.medium
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İmza Kayıt"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the size for the square container (based on the smallest constraint)
                double size = constraints.maxWidth < constraints.maxHeight
                    ? constraints.maxWidth
                    : constraints.maxHeight;

                return Container(
                  width: size, // Square size
                  height: size, // Square size
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: 1 / 0.7,
                          child: ClipRect(
                            child: Transform.scale(
                              scale: _controller.value.aspectRatio / 0.7,
                              child: Center(
                                child: CameraPreview(_controller),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  if (!context.mounted) return;
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FotoDuzen(
                        imza: widget.imza,
                        photo: image,
                      ),
                    ),
                  );
                } catch (e) {
                  print("dsıuagdhsahdsjakd");
                }
              },
              child: Text("Deklanşör"),
            ),
          ),
        ],
      ),
    );
  }
}
