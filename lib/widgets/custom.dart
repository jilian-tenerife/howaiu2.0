import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomTile extends StatelessWidget {
  final String text;
  final VoidCallback onFeedbackTap;
  final VoidCallback onOtherTap;

  const CustomTile({
    Key? key,
    required this.text,
    required this.onFeedbackTap,
    required this.onOtherTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text)),
            Row(
              children: [
                NeumorphicButton(
                  onPressed: onFeedbackTap,
                  style: NeumorphicStyle(
                    color: Colors.grey[300],
                    depth: 8,
                    intensity: 0.7,
                    lightSource: LightSource.topLeft,
                    shape: NeumorphicShape.convex,
                  ),
                  child: Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5d7599),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                NeumorphicButton(
                    onPressed: onOtherTap,
                    style: NeumorphicStyle(
                      color: Colors.grey[300],
                      depth: 8,
                      intensity: 0.7,
                      lightSource: LightSource.topLeft,
                      shape: NeumorphicShape.convex,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xff5d7599),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
