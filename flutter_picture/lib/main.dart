import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFe91e63),
        accentColor: const Color(0xFFe91e63),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyImagePage(),
    );
  }
}

class MyImagePage extends StatefulWidget {
  @override
  _MyImagePageState createState() => _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage> {
  File image;
  GlobalKey _homeStateKey = GlobalKey();
  List<List<Offset>> strokes = new List<List<Offset>>();
  MyPainter _painter;
  ui.Image targetImage;
  Size mediaSize;
  double _r = 255.0;
  double _g = 0;
  double _b = 0;

  _MyImagePageState() {
    requestPermission();
  }

  void requestPermission() async {
    await PermissionHandler()
        .requestPermissions([PermissionGroup.camera, PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Canture Image Drawing!'),
      ),
      body: Listener(
        onPointerDown: _pointerDown,
        onPointerMove: _pointerMove,
        child: Container(
          child: CustomPaint(
            key: _homeStateKey,
            painter: _painter,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
            ),
          ),
        ),
      ),
      floatingActionButton: image == null
          ? FloatingActionButton(
              onPressed: getImage,
              tooltip: 'take a picture!',
              child: Icon(Icons.add_a_photo),
            )
          : FloatingActionButton(
              onPressed: saveImage,
              tooltip: 'save Image',
              child: Icon(Icons.save),
            ),
      drawer: Drawer(
          child: Center(
              child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Set Color...', style: TextStyle(fontSize: 20.0)),
          ),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Slider(min: 0.0, max: 255, value: _r, onChanged: sliderR)),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Slider(min: 0.0, max: 255, value: _g, onChanged: sliderG)),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Slider(min: 0.0, max: 255, value: _b, onChanged: sliderB)),
        ],
      ))),
    );
  }

  void sliderR(double value) {
    setState(() => _r = value);
  }

  void sliderG(double value) {
    setState(() => _g = value);
  }

  void sliderB(double value) {
    setState(() => _b = value);
  }

  void createMyPainter() {
    var strokeColor = Color.fromARGB(200, _r.toInt(), _g.toInt(), _b.toInt());
    _painter = MyPainter(targetImage, image, strokes, mediaSize, strokeColor);
  }

  void getImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    image = file;
    loadImage(image.path);
  }

  void saveImage() {
    _painter.saveImage();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Saved!"),
              content: Text("save image to file."),
            ));
  }

  loadImage(path) async {
    List<int> byts = await image.readAsBytes();
    Uint8List u8lst = Uint8List.fromList(byts);
    ui.instantiateImageCodec(u8lst).then((codec) {
      codec.getNextFrame().then((frameInfo) {
        targetImage = frameInfo.image;
        setState(() {
          createMyPainter();
        });
      });
    });
  }

  void _pointerDown(PointerDownEvent event) {
    RenderBox referenceBox = _homeStateKey.currentContext.findRenderObject();
    strokes.add([referenceBox.globalToLocal(event.position)]);
    setState(() {
      createMyPainter();
    });
  }

  void _pointerMove(PointerMoveEvent event) {
    RenderBox referenceBox = _homeStateKey.currentContext.findRenderObject();
    strokes.last.add(referenceBox.globalToLocal(event.position));
    setState(() {
      createMyPainter();
    });
  }
}

class MyPainter extends CustomPainter {
  File image;
  ui.Image targetImage;
  Size mediaSize;
  Color strokeColor;
  var strokes = new List<List<Offset>>();
  MyPainter(this.targetImage, this.image, this.strokes, this.mediaSize,
      this.strokeColor);

  @override
  void paint(Canvas canvas, Size size) {
    mediaSize = size;
    drawToCanvas()
        .then((im) => canvas.drawImage(im, Offset(0.0, 0.0), Paint()));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void saveImage() async {
    ui.Image img = await drawToCanvas();
    final ByteData byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    int epoch = new DateTime.now().millisecondsSinceEpoch;
    final file = new File(image.parent.path + '/' + epoch.toString() + '.png');
    file.writeAsBytes(byteData.buffer.asUint8List());
  }

  Future<ui.Image> drawToCanvas() {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = Canvas(recorder);

    Paint p1 = Paint();
    p1.color = Colors.white;
    canvas.drawColor(Colors.white, BlendMode.color);

    if (targetImage != null) {
      Rect r1 = Rect.fromPoints(Offset(0.0, 0.0),
          Offset(targetImage.width.toDouble(), targetImage.height.toDouble()));
      Rect r2 = Rect.fromPoints(Offset(0.0, 0.0),
          Offset(mediaSize.width.toDouble(), mediaSize.height.toDouble()));
      canvas.drawImageRect(targetImage, r1, r2, p1);
    }

    Paint p2 = new Paint();
    p2.color = strokeColor;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 5.0;

    for (var stroke in strokes) {
      Path strokePath = new Path();
      strokePath.addPolygon(stroke, false);
      canvas.drawPath(strokePath, p2);
    }

    ui.Picture picture = recorder.endRecording();
    return picture.toImage(mediaSize.width.toInt(), mediaSize.height.toInt());
  }
}
