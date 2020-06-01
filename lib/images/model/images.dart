/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/widgets.dart';

import './collection_item_image.dart';
import '../../shared/model/model_id.dart';

abstract class ImageRepository {
  Future<CollectionItemImage> add(
      File imageFile, bool isMainImage, ModelID parent);

  Future<void> remove(ModelID<CollectionItemImage> id);

  Future<void> toggleIsMainImage(
      {ModelID<CollectionItemImage> newMainImageId,
      ModelID<CollectionItemImage> oldMainImageId});

  Future<List<CollectionItemImage>> loadImages(ModelID parent);
}

class Images with ChangeNotifier {
  final ModelID parent;
  final ImageRepository repository;
  final List<ImageDescriptor> _images = [];
  ImageDescriptor _mainImage;

  Images({@required this.parent, @required this.repository});

  List<ImageDescriptor> get images => _images;

  Future<ImageDescriptor> addImage(File image) async {
    final CollectionItemImage collectionImage =
        await repository.add(image, _mainImage == null, parent);
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
      if (_mainImage != null) {
        await repository.toggleIsMainImage(
            newMainImageId: _mainImage._id, oldMainImageId: null);
      }
    }
    notifyListeners();
  }

  ImageDescriptor get mainImage => _mainImage;

  Future<bool> _toggleIsMain(ImageDescriptor image) async {
    final oldMainImageId = _mainImage?._id;
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
      await repository.toggleIsMainImage(
          newMainImageId: _mainImage._id, oldMainImageId: oldMainImageId);
      notifyListeners();
    }
    return hasToggled;
  }

  Future<void> fetchImages() async {
    _images.clear();
    _mainImage = null;
    final List<CollectionItemImage> loaded = await repository.loadImages(parent);

    if (loaded != null) {
      _images.addAll(loaded
          ?.map(
              (e) => ImageDescriptor(parent: this, id: e.id, path: e.fileName))
          ?.toList());
      CollectionItemImage mainImage = loaded
          ?.firstWhere((element) => element.isMainImage, orElse: () => null);
      _mainImage = mainImage != null
          ? ImageDescriptor(
              parent: this, id: mainImage.id, path: mainImage.fileName)
          : null;
    }

    if (_mainImage == null && _images.length > 0) {
      _mainImage = _images[0];
    }

    notifyListeners();
  }
}

class ImageDescriptor {
  final Images parent;
  final String path;
  final ModelID<CollectionItemImage> _id;

  ImageDescriptor(
      {@required this.parent,
      @required this.path,
      @required ModelID<CollectionItemImage> id})
      : assert(parent != null && path != null && id != null),
        _id = id;
  factory ImageDescriptor.fromImage(CollectionItemImage image, Images model) {
    if (image == null) return null;
    return ImageDescriptor(parent: model, path: image.fileName, id: image.id);
  }

  File toFile() {
    return File(path);
  }

  bool get isMainImage => parent._mainImage == this;
  Future<bool> toggleIsMainImage() async => parent._toggleIsMain(this);
  void remove() => parent.removeImage(this);
}
