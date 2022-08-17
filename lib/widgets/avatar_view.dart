import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class AvatarView extends StatelessWidget {
  const AvatarView({
    Key? key,
    this.size = 100,
    this.url,
    this.isCircle = false,
  }) : super(key: key);
  final double size;
  final String? url;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url ?? '',
      width: size,
      height: size,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => Icon(Icons.cloud_download),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    if (isCircle)
      return  ClipOval(
        child: image,
      );
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: image,
    );

  }
}
