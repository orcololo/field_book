import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

bool isNetworkPath(String path) => path.startsWith('http');

ImageProvider adaptiveImageProvider(String path) {
  if (isNetworkPath(path)) {
    return CachedNetworkImageProvider(path);
  }
  return FileImage(File(path));
}

class AdaptiveImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AdaptiveImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isNetworkPath(path)) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) {
          if (errorBuilder != null) {
            return errorBuilder!(context, error, null);
          }
          return _defaultError(context);
        },
      );
    }

    final file = File(path);
    if (!file.existsSync()) {
      if (errorBuilder != null) {
        return errorBuilder!(context, Exception('File not found'), null);
      }
      return _defaultError(context);
    }

    return Image.file(
      file,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }

  Widget _defaultError(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
