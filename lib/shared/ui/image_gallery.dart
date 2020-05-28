/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

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

class _AddImageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: FlatButton(
      child: Icon(Icons.add),
      onPressed: _openImagePicker,
    ));
  }

  Future _openImagePicker() async {}
}
