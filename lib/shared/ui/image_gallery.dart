/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './expanded_section.dart';

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
        //width: MediaQuery.of(context).size.width,
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
  final ImageDescriptor imageDescriptor = ImageDescriptor(
      //'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg');
      'https://www.bonsaipflege.ch/images/bilder/Bonsai%20-%20Nadel/E-H/Picea_.jpg');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            imageDescriptor.location,
            fit: BoxFit.cover,
          )),
    );
  }
}

class _ImagePanel extends StatelessWidget {
  final List<ImageDescriptor> images = [
    ImageDescriptor(
        'https://www.gartenjournal.net/wp-content/uploads/fichte-bonsai.jpg'),
    ImageDescriptor(
        'https://www.bonsaipflege.ch/images/bilder/Bonsai%20-%20Nadel/E-H/Picea_.jpg'),
    ImageDescriptor(
        'https://www.gartenjournal.net/wp-content/uploads/fichte-bonsai.jpg'),
    ImageDescriptor(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
    ImageDescriptor(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
    ImageDescriptor(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _AddImageTile(),
        //Row()
        Expanded(
            child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return _ImageTile(images[index]);
                  },
                )))
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  final ImageDescriptor imageDescriptor;
  _ImageTile(this.imageDescriptor);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(imageDescriptor.location, fit: BoxFit.cover)));
  }
}

class _AddImageTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddImageTileState();
}

class _AddImageTileState extends State<_AddImageTile>
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
                child: Icon(Icons.camera),
                onPressed: () {},
              ),
              FlatButton(
                child: Icon(Icons.image),
                onPressed: () {},
              )
            ])),
      ],
    ));
  }
}

Future _openImagePicker() async {
  //await ImagePicker.pickImage(source: ImageSource.camera);
}
