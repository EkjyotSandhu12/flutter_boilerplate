import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/screen_utils.dart';

class NetworkImageWidget extends StatefulWidget {
  NetworkImageWidget(this.imageUrl);

  final String imageUrl;

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
      cacheWidth: (ScreenUtils.getScreenWidth(context, ratio: .4).toInt()),
      alignment: Alignment.center,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
      wasSynchronouslyLoaded
          ? child
          : AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut,
        child: child,
      ),
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Center(
        child: LinearProgressIndicator(),
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
                Text('$error', textAlign: TextAlign.center),
                IconButton(
                    onPressed: () {
                      setState(() {
                        reloadKey++;
                      });
                    },
                    icon: Icon(
                      Icons.sync_problem,
                      size: 38,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

class FileImageWidget extends StatelessWidget {
  FileImageWidget({this.isAsset = false, required this.imageUrl});

  final String imageUrl;
  bool isAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isAsset
          ? Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frameBuilder(context, child, frame, wasSynchronouslyLoaded),
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, error, stackTrace),
      )
          : Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frameBuilder(context, child, frame, wasSynchronouslyLoaded),
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, error, stackTrace),
      ),
    );
  }

  frameBuilder(BuildContext context, Widget child, int? frame,
      bool wasSynchronouslyLoaded) =>
      wasSynchronouslyLoaded
          ? child
          : frame == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : child;

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
