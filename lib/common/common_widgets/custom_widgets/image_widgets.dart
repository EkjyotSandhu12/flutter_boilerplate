import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/screen_utils.dart';
import '../app_widgets/custom_circular_loader_widget.dart';

class NetworkImageWidget extends StatefulWidget {
  NetworkImageWidget(this.imageUrl,
      {this.cacheWidth, this.hasImageLoaded, this.loadingWidget});

  final String imageUrl;
  int? cacheWidth;
  Function(bool)? hasImageLoaded;
  Widget? loadingWidget;

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  int reloadKey = 0;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      key: ValueKey("$reloadKey ${widget.imageUrl}"),
      fit: BoxFit.cover,
      cacheWidth: widget.cacheWidth,
      alignment: Alignment.center,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frameBuilder(context, child, frame, wasSynchronouslyLoaded,
              hasImageLoaded: widget.hasImageLoaded,
              loadingWidget: widget.loadingWidget),
      loadingBuilder: (
          context,
          child,
          progress,
          ) =>
      progress == null
          ? child
          : widget.loadingWidget ??
          Center(
            child: CustomCircularLoaderWidget(),
          ),
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        reloadKey++;
                      });
                    },
                    icon: Icon(
                      Icons.sync_problem,
                      size: 38,
                    )),
                Text('$error', textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FileImageWidget extends StatelessWidget {
  FileImageWidget(
      {this.isAsset = false, required this.imageUrl, this.cacheWidth});

  final String imageUrl;
  bool isAsset;
  int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isAsset
          ? Image.asset(
        cacheWidth: cacheWidth,
        imageUrl,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frameBuilder(context, child, frame, wasSynchronouslyLoaded),
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, error, stackTrace),
      )
          : Image.file(
        cacheWidth: cacheWidth,
        File(imageUrl),
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frameBuilder(context, child, frame, wasSynchronouslyLoaded),
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, error, stackTrace),
      ),
    );
  }

  errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$error', textAlign: TextAlign.center),
          ],
        ),
      );
}

frameBuilder(
    BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded,
    {Function(bool)? hasImageLoaded, Widget? loadingWidget}) {
  child = Animate(
    effects: [FadeEffect()],
    child: child,
  );

  if (hasImageLoaded != null) {
    hasImageLoaded(frame == null);
  }

  return wasSynchronouslyLoaded
      ? child
      : frame == null
      ? loadingWidget ??
      Center(
        child: CustomCircularLoaderWidget(),
      )
      : child;
}
