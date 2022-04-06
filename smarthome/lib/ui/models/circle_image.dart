import 'package:flutter/material.dart';
import 'models.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({Key? key, required this.imageRadius, this.imageProvider}) : super(key: key);
  final double imageRadius;
  final ImageProvider? imageProvider;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: imageRadius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundImage: imageProvider,
        radius: imageRadius - 5,
      ),
    );
  }
}
