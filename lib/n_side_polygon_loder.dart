import 'package:flutter/material.dart';
import 'package:n_side_progress_bar/CustomPaintComponent/polygon_loader.dart';

class NSidePolygonLoder extends StatefulWidget {
  const NSidePolygonLoder({Key? key}) : super(key: key);

  @override
  State<NSidePolygonLoder> createState() => _NSidePolygonLoderState();
}

class _NSidePolygonLoderState extends State<NSidePolygonLoder> {
  int _sides = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "N-SidePolygonLoder",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: PolygonProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  strokeWidth: 5,
                  sides: _sides,
                  borderRadius: 5,
                ),
              ),
            ),
            const Spacer(flex: 1),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Sides'),
            ),
            Slider(
              value: _sides.toDouble(),
              activeColor: Colors.black,
              min: 0.0,
              max: 14.0,
              label: _sides.toInt().toString(),
              divisions: 14,
              onChanged: (value) {
                setState(() {
                  _sides = value.toInt();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
