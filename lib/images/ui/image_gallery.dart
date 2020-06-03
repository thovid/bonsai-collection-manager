/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/expanded_section.dart';
import '../i18n/image_gallery.i18n.dart';
import '../model/images.dart';

typedef Future<void> ImageSelectedCallback(File imageFile);

class ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(flex: 4, child: MainImageTile()),
        Expanded(child: ImagesPanel()),
      ],
    ));
  }
}

class MainImageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Images>(
        builder: (context, imageGalleryModel, _) => Container(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: _buildImageOrHint(context, imageGalleryModel)),
            ));
  }

  Widget _buildImageOrHint(BuildContext context, Images model) {
    if (model.mainImage != null)
      return _buildTapableImage(context, model.mainImage);
    return Center(child: Text("Add your first image".i18n));
  }
}

class ImagesPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Images>(
        builder: (context, imageGalleryModel, _) => Column(
              children: <Widget>[
                ImagesPanelMenuTile(
                  onImageSelected: imageGalleryModel.addImage,
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: ListView.builder(
                          itemCount: imageGalleryModel.images.length,
                          itemBuilder: (context, index) {
                            return ImageTile(imageGalleryModel.images[index]);
                          },
                        )))
              ],
            ));
  }
}

class ImageTile extends StatelessWidget {
  final ImageDescriptor imageDescriptor;
  ImageTile(this.imageDescriptor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: _buildTapableImage(context, imageDescriptor),
      ),
    );
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
                  await _openImagePicker(ImageSource.camera)
                      .then((image) => _handleImagePicked(image));
                },
              ),
              FlatButton(
                child: Icon(Icons.add_photo_alternate),
                onPressed: () async {
                  await _openImagePicker(ImageSource.gallery)
                      .then((image) => _handleImagePicked(image));
                },
              )
            ])),
      ],
    ));
  }

  Future<File> _openImagePicker(ImageSource source) async {
    return await ImagePicker.pickImage(source: source);
  }

  Future<void> _handleImagePicked(File image) async {
    if (image == null) {
      return;
    }

    _animationController.reverse();
    setState(() {
      _showSelector = false;
    });
    widget.onImageSelected(image);
  }
}

class ImagePopup extends StatefulWidget {
  final ImageDescriptor image;

  ImagePopup(this.image);

  @override
  _ImagePopupState createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  bool isMainImage;

  @override
  void initState() {
    super.initState();
    isMainImage = widget.image.isMainImage;
  }

  @override
  void didUpdateWidget(ImagePopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    isMainImage = widget.image.isMainImage;
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
                    child: Image.file(
                      widget.image.toFile(),
                      fit: BoxFit.contain,
                      errorBuilder: _defaultImageNotFound,
                    )),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.image.remove();
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(
                      isMainImage ? Icons.favorite : Icons.favorite_border),
                  onPressed: () async {
                    bool hasToggled = await widget.image.toggleIsMainImage();
                    if (hasToggled) {
                      setState(() {
                        isMainImage = !isMainImage;
                      });
                    }
                  },
                ),
              ]),
            ]),
          ),
        ),
      );
}

GestureDetector _buildTapableImage(
    BuildContext context, ImageDescriptor image) {
  return GestureDetector(
    onTap: () async {
      await showDialog(
          context: context, builder: (context) => ImagePopup(image));
    },
    child: Image.file(
      image.toFile(),
      fit: BoxFit.cover,
      errorBuilder: _defaultImageNotFound,
    ),
  );
}

Widget _defaultImageNotFound(BuildContext c, Object o, StackTrace s) =>
    Column(children: [Icon(Icons.report_problem), Text('not found')]);
