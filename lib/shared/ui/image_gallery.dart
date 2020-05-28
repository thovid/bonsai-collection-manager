/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import './expanded_section.dart';

class ImageGalleryModel with ChangeNotifier {
  ImageDescriptor _primary;
  List<ImageDescriptor> _images;

  ImageGalleryModel({ImageDescriptor primary, List<ImageDescriptor> images})
      : _primary = primary,
        _images = images;

  List<ImageDescriptor> get images => _images;

  void addImage(ImageDescriptor image) {
    _images.insert(0, image);
    notifyListeners();
  }

  ImageDescriptor get primaryImage => _primary;

  set primaryImage(ImageDescriptor image) {
    _primary = image;
    notifyListeners();
  }
}

class ImageDescriptor {
  final String location;

  ImageDescriptor(this.location);
}

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
            Expanded(flex: 4, child: _MainImage()),
            Expanded(child: _ImagePanel()),
          ],
        )));
  }
}

class _MainImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImageGalleryModel>(
        builder: (BuildContext context, ImageGalleryModel imageGalleryModel,
                Widget _) =>
            Container(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    imageGalleryModel.primaryImage.location,
                    fit: BoxFit.cover,
                  )),
            ));
  }
}

class _ImagePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImageGalleryModel>(
        builder: (context, imageGalleryModel, _) => Column(
              children: <Widget>[
                _MenuTile(),
                //Row()
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: ListView.builder(
                          itemCount: imageGalleryModel.images.length,
                          itemBuilder: (context, index) {
                            return _ImageTile(imageGalleryModel.images[index]);
                          },
                        )))
              ],
            ));
  }
}

class _ImageTile extends StatelessWidget {
  final ImageDescriptor imageDescriptor;
  _ImageTile(this.imageDescriptor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              // TODO extract into distinct widget, use for main image, add close button
              builder: (context) => Dialog(
                      child: IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      //width: MediaQuery.of(context).size.width * .9,
                      //height: MediaQuery.of(context).size.height * .5,
                      child: Column(children: [
                        Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(imageDescriptor.location,
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                  Icons.star_border,
                                  //color: Colors.amberAccent,
                                ),
                                onPressed: () {
                                  print("starred");
                                },
                              ),
                            ]),
                      ]),
                    ),
                  )));
        },
        child: Container(
            padding: EdgeInsets.all(5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(imageDescriptor.location,
                    fit: BoxFit.cover))));
  }
}

class _MenuTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile>
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
                child: Icon(Icons.photo_camera),
                onPressed: () async {
                  _handleImagePicked(
                      await _openImagePicker(ImageSource.camera));
                },
              ),
              FlatButton(
                child: Icon(Icons.photo_album),
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
    _animationController.reverse();
    setState(() {
      _showSelector = false;
    });
  }
}
