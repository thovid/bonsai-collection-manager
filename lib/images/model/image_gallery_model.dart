/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/widgets.dart';

import './collection_item_image.dart';
import '../../shared/model/model_id.dart';

abstract class ImageRepository {
  Future<CollectionItemImage> add(File imageFile);

  Future<void> remove(ModelID<CollectionItemImage> id);

  Future<void> toggleIsMainImage(ModelID<CollectionItemImage> id);
}

class ImageGalleryModel with ChangeNotifier {
  final ImageRepository repository;
  final List<ImageDescriptor> _images = [];
  ImageDescriptor _mainImage;

  ImageGalleryModel(
      {ImageDescriptor mainImage,
      List<ImageDescriptor> images = const [],
      @required this.repository})
      : _mainImage = mainImage {
    _images.addAll(images);
    if (_mainImage == null && _images.length > 0) {
      _mainImage = _images[0];
    }
  }

  List<ImageDescriptor> get images => _images;

  Future<ImageDescriptor> addImage(File image) async {
    final CollectionItemImage collectionImage = await repository.add(image);
    ImageDescriptor descriptor =
        ImageDescriptor(parent: this, path: image.path, id: collectionImage.id);
    if (_images.isEmpty) {
      _mainImage = descriptor;
    }
    _images.insert(0, descriptor);
    notifyListeners();
    return descriptor;
  }

  Future<void> removeImage(ImageDescriptor image) async {
    await repository.remove(image._id);
    _images.remove(image);
    if (image == _mainImage) {
      _mainImage = _images.length > 0 ? _images[0] : null;
    }
    notifyListeners();
  }

  ImageDescriptor get mainImage => _mainImage;

  Future<bool> _toggleIsMain(ImageDescriptor image) async {
    final bool wasMain = image == _mainImage;
    if (_mainImage == image) {
      if (_mainImage == images[0] && images.length > 1) {
        _mainImage = images[1];
      } else {
        _mainImage = images[0];
      }
    } else {
      _mainImage = image;
    }
    final bool isMain = image == _mainImage;
    final bool hasToggled = wasMain != isMain;
    if (hasToggled) {
      await repository.toggleIsMainImage(image._id);
      notifyListeners();
    }
    return hasToggled;
  }
}

class ImageDescriptor {
  final ImageGalleryModel parent;
  final String path;
  final ModelID<CollectionItemImage> _id;

  ImageDescriptor(
      {@required this.parent,
      @required this.path,
      @required ModelID<CollectionItemImage> id})
      : assert(parent != null && path != null && id != null),
        _id = id;

  File toFile() {
    return File(path);
  }

  bool get isMainImage => parent._mainImage == this;
  Future<bool> toggleIsMainImage() async => parent._toggleIsMain(this);
  void remove() => parent.removeImage(this);
}
