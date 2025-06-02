import 'dart:async';

import 'package:flutter/material.dart';

class ProportionalImage extends StatefulWidget {
  final String? imageUrl;
  const ProportionalImage({super.key, required this.imageUrl});

  @override
  State<ProportionalImage> createState() => _ProportionalImageState();
}

class _ProportionalImageState extends State<ProportionalImage> {
  double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final fixedWidth = MediaQuery.of(context).size.width;

    if (!_isValidUrl(widget.imageUrl)) {
      return _buildFallbackImage(fixedWidth);
    }

    if (aspectRatio == null) {
      return SizedBox(
        width: fixedWidth,
        height: 150,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: fixedWidth,
      child: AspectRatio(
        aspectRatio: aspectRatio!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            widget.imageUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              // While loading: show placeholder
              return Image.asset(
                "assets/images/placeholder_16.png",
                fit: BoxFit.cover,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackImage(fixedWidth);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (_isValidUrl(widget.imageUrl)) {
      _getImageAspectRatio(widget.imageUrl!);
    }
  }

  Widget _buildFallbackImage(double width) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/placeholder_16.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _getImageAspectRatio(String url) async {
    final image = Image.network(url);
    final completer = Completer<ImageInfo>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, _) {
        completer.complete(info);
      }),
    );

    try {
      final info = await completer.future;
      final width = info.image.width;
      final height = info.image.height;

      if (mounted) {
        setState(() {
          aspectRatio = width / height;
        });
      }
    } catch (_) {
      // Let errorBuilder handle it
    }
  }

  bool _isValidUrl(String? url) {
    return url != null && url.trim().isNotEmpty;
  }
}
