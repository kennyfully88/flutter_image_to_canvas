// For flutter 3.10
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

// This function async loads an image from the assets folder
Future<ui.Image> loadImage(String imageName) async {
  final data = await rootBundle.load('assets/$imageName');
  return decodeImageFromList(data.buffer.asUint8List());
}

// This global variable will be initialized when first used
late ui.Image image;

// The entry point into the app
void main() async {
  // Must run this first for main async function
  WidgetsFlutterBinding.ensureInitialized();

  // Return an image to this variable via the loadImage function
  image = await loadImage('example_image.png');

  // Run app
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          Text(
            'Image drawn on Flutter canvas',
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          ClipRect(
            child: GameCanvas(),
          ),
        ],
      ),
    );
  }
}
// Somwhere in the app draw on the canvas with the global variable "image"
// ex: canvas.drawImage(image, Offset.zero, Paint());

class GameCanvas extends StatefulWidget {
  const GameCanvas({super.key});

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[600],
      child: CustomPaint(
        size: const Size(256, 256),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Rect rectSrc = const Rect.fromLTWH(16 * 3, 0, 16, 32);
    Rect rectDst = const Rect.fromLTWH(0, 0, 16, 32);

    canvas.drawImageRect(image, rectSrc, rectDst, paint);

    canvas.drawImageRect(image, const Rect.fromLTWH(16 * 4, 0, 16, 32),
        const Rect.fromLTWH(16, 0, 16, 32), paint);

    // canvas.drawImage(image, const Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
