/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import './collection_item_image_table.dart';
import '../model/collection_item_image.dart';
import '../model/image_gallery_model.dart';
import '../../shared/infrastructure/base_repository.dart';
import '../../shared/model/model_id.dart';

class SQLImageGalleryRepository extends BaseRepository with ImageRepository {
  @override
  Future<CollectionItemImage> add(
      File imageFile, bool isMainImage, ModelID parentID) async {
    CollectionItemImage image = (CollectionItemImageBuilder()
          ..parentId = parentID
          ..fileName = imageFile.path
          ..isMainImage = isMainImage)
        .build();
    await init().then((db) => CollectionItemImageTable.write(image, db));
    return image;
  }

  @override
  Future<void> remove(ModelID<CollectionItemImage> id) async {
    return init().then((db) => CollectionItemImageTable.delete(id, db));
  }

  @override
  Future<void> toggleIsMainImage(
      {ModelID<CollectionItemImage> newMainImageId,
      ModelID<CollectionItemImage> oldMainImageId}) async {
    return init().then((value) => value.transaction((transaction) async {
          if (oldMainImageId != null) {
            CollectionItemImageTable.setMainImageFlag(
                oldMainImageId, false, transaction);
          }
          CollectionItemImageTable.setMainImageFlag(
              newMainImageId, true, transaction);
        }));
  }

  @override
  Future<List<CollectionItemImage>> loadImages(ModelID parent) async {
    return init()
        .then((db) => CollectionItemImageTable.readForItem(parent, db));
  }
}
