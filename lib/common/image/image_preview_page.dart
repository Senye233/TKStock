import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tkstock/common/image/hero_widget.dart';

class TransparentRoute extends PageRouteBuilder {
  final Widget page;

  TransparentRoute({required this.page})
      : super(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({super.key, required this.url});

  final String url;

  @override
  State createState() => _ImagePreviewPageState();

  static show(BuildContext context, String url) {
    Navigator.of(context).push(TransparentRoute(page: ImagePreviewPage(url: url)));
  }
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  GlobalKey<ExtendedImageSlidePageState> slidePageKey = GlobalKey<ExtendedImageSlidePageState>();

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (widget.url.startsWith('http')) {
      image = ExtendedImage.network(
        widget.url,
        // 开了这个就不能滑动消失了
        mode: ExtendedImageMode.gesture,
        enableSlideOutPage: true,
      );
    } else {
      image = ExtendedImage.file(
        File(widget.url),
        // 开了这个就不能滑动消失了
        mode: ExtendedImageMode.gesture,
        enableSlideOutPage: true,
      );
    }
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePageKey,
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
        slidePageBackgroundHandler: (offset, pageSize) {
          final opacity = offset.distance / (Offset(pageSize.width, pageSize.height).distance / 2.0);
          return Colors.white.withValues(alpha: min(1.0, max(1.0 - opacity, 0.0)) * 0.5);
        },
        child: GestureDetector(
          child: HeroWidget(
            tag: widget.url,
            slideType: SlideType.onlyImage,
            slidePagekey: slidePageKey,
            child: image,
          ),
          onTap: () {
            // slidePagekey.currentState!.popPage();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
