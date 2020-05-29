/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../i18n/image_gallery.i18n.dart';
import './expanded_section.dart';

class ImageGalleryModel with ChangeNotifier {
  final List<ImageDescriptor> _images = [];
  ImageDescriptor _primary;

  ImageGalleryModel(
      {ImageDescriptor primary, List<ImageDescriptor> images = const []})
      : _primary = primary {
    _images.addAll(images);
    if (_primary == null && _images.length > 0) {
      _primary = _images[0];
    }
  }

  List<ImageDescriptor> get images => _images;

  void addImage(ImageDescriptor image) {
    if (_images.isEmpty) {
      _primary = image;
    }
    _images.insert(0, image);
    notifyListeners();
  }

  void removeImage(ImageDescriptor image) {
    _images.remove(image);
    // TODO update primary
    notifyListeners();
  }

  ImageDescriptor get primaryImage => _primary;

  set primaryImage(ImageDescriptor image) {
    _primary = image;
    notifyListeners();
  }

  bool toggleIsPrimary(ImageDescriptor image) {
    final bool wasPrimary = image == _primary;
    if (_primary == image) {
      if (_primary == images[0] && images.length > 1) {
        _primary = images[1];
      } else {
        _primary = images[0];
      }
    } else {
      _primary = image;
    }
    final bool isPrimary = image == _primary;
    notifyListeners();
    return wasPrimary != isPrimary;
  }
}

class ImageDescriptor {
  final String path;

  ImageDescriptor({@required this.path}) : assert(path != null);
}

typedef void ImageSelectedCallback(ImageDescriptor image);

class ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * .5 - 20,
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(flex: 4, child: MainImageTile()),
            Expanded(child: ImagesPanel()),
          ],
        )));
  }
}

class MainImageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImageGalleryModel>(
        builder: (context, imageGalleryModel, _) => Container(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: _buildImageOrHint(context, imageGalleryModel)),
            ));
  }

  Widget _buildImageOrHint(BuildContext context, ImageGalleryModel model) {
    if (model.primaryImage != null)
      return _buildTapableImage(context, model.primaryImage, true,
          () => model.toggleIsPrimary(model.primaryImage));
    return Center(child: Text("Add your first image".i18n));
  }
}

class ImagesPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImageGalleryModel>(
        builder: (context, imageGalleryModel, _) => Column(
              children: <Widget>[
                ImagesPanelMenuTile(
                  onImageSelected: imageGalleryModel.addImage,
                ),
                //Row()
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: ListView.builder(
                          itemCount: imageGalleryModel?.images?.length ?? 0,
                          itemBuilder: (context, index) {
                            ImageDescriptor image =
                                imageGalleryModel.images[index];
                            return ImageTile(
                              image,
                              image == imageGalleryModel.primaryImage,
                              () => imageGalleryModel.toggleIsPrimary(image),
                            );
                          },
                        )))
              ],
            ));
  }
}

class ImageTile extends StatelessWidget {
  final ImageDescriptor imageDescriptor;
  final bool isMainImage;
  final bool Function() onToggleFavorite;
  ImageTile(this.imageDescriptor, this.isMainImage, this.onToggleFavorite);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: _buildTapableImage(
                context, imageDescriptor, isMainImage, onToggleFavorite)));
  }
}

class ImagesPanelMenuTile extends StatefulWidget {
  final ImageSelectedCallback onImageSelected;

  const ImagesPanelMenuTile({@required this.onImageSelected})
      : assert(onImageSelected != null);
  @override
  State<StatefulWidget> createState() => _ImagesPanelMenuTileState();
}

class _ImagesPanelMenuTileState extends State<ImagesPanelMenuTile>
    with SingleTickerProviderStateMixin {
  bool _showSelector = false;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        FlatButton(
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
          onPressed: () {
            if (!_showSelector)
              _animationController.forward();
            else
              _animationController.reverse();
            setState(() {
              _showSelector = !_showSelector;
            });
          },
        ),
        ExpandedSection(
            expand: _showSelector,
            child: Column(children: [
              FlatButton(
                child: Icon(Icons.add_a_photo),
                onPressed: () async {
                  _handleImagePicked(
                      await _openImagePicker(ImageSource.camera));
                },
              ),
              FlatButton(
                child: Icon(Icons.add_photo_alternate),
                onPressed: () async {
                  _handleImagePicked(
                      await _openImagePicker(ImageSource.gallery));
                },
              )
            ])),
      ],
    ));
  }

  Future<File> _openImagePicker(ImageSource source) async {
    return await ImagePicker.pickImage(source: source);
  }

  void _handleImagePicked(File image) {
    if (image == null) {
      return;
    }

    _animationController.reverse();
    setState(() {
      _showSelector = false;
    });
    widget.onImageSelected(ImageDescriptor(path: image.path));
  }
}

class ImagePopup extends StatefulWidget {
  final Image image;
  final bool isMainImage;
  final bool Function() onToggleFavorite;
  ImagePopup(
      {@required this.image,
      @required this.isMainImage,
      @required this.onToggleFavorite});

  @override
  _ImagePopupState createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  bool isMainImage;

  @override
  void initState() {
    super.initState();
    isMainImage = widget.isMainImage;
  }

  @override
  void didUpdateWidget(ImagePopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    isMainImage = widget.isMainImage;
  }

  @override
  Widget build(BuildContext context) => Dialog(
          child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: widget.image),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  print("deleted");
                },
              ),
              IconButton(
                icon: Icon(
                  isMainImage ? Icons.favorite : Icons.favorite_border,
                  //color: Colors.amberAccent,
                ),
                onPressed: () {
                  if (widget.onToggleFavorite()) {
                    setState(() {
                      isMainImage = !isMainImage;
                    });
                  }
                },
              ),
            ]),
          ]),
        ),
      ));
}

GestureDetector _buildTapableImage(BuildContext context, ImageDescriptor image,
    bool isMainImage, bool Function() onToggleFavorite) {
  final File file = File(image.path);
  return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => ImagePopup(
                isMainImage: isMainImage,
                onToggleFavorite: onToggleFavorite,
                image: Image.file(
                  file,
                  fit: BoxFit.contain,
                  errorBuilder: _defaultImageNotFound,
                )));
      },
      child: Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: _defaultImageNotFound,
      ));
}

Widget _defaultImageNotFound(BuildContext c, Object o, StackTrace s) =>
    Icon(Icons.report_problem);
