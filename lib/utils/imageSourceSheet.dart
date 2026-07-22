import 'package:flutter/cupertino.dart';

class ImageSourceActionSheet extends StatelessWidget {
  final VoidCallback onCameraSelected;
  final VoidCallback onGallerySelected;

  const ImageSourceActionSheet({
    super.key,
    required this.onCameraSelected,
    required this.onGallerySelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Choose From'),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            onCameraSelected();
          },
          child: Text('Camera'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            onGallerySelected();
          },
          child: Text('Gallery'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
