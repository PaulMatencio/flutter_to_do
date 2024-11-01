import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)));
  }
}
