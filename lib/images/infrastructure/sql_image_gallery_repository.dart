/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import './collection_item_image_table.dart';
import '../model/collection_item_image.dart';
import '../model/images.dart';
import '../../shared/infrastructure/base_repository.dart';
import '../../shared/model/model_id.dart';

class SQLImageGalleryRepository extends BaseRepository with ImageRepository {
  @override
  Future<CollectionItemImage> add(
      File imageFile, bool isMainImage, ModelID parentID) async {
    final String path = (await _persistImage(imageFile, parentID)).path;

    final CollectionItemImage image = (CollectionItemImageBuilder()
          ..parentId = parentID
          ..fileName = path
          ..isMainImage = isMainImage)
        .build();
    await init().then((db) => CollectionItemImageTable.write(image, db));
    return image;
  }

  @override
  Future<void> remove(ModelID<CollectionItemImage> id) async {
    return init().then((db) => db.transaction((txn) async {
          CollectionItemImageTable.read(id, txn).then((image) {
            final File imageFile = File(image.fileName);
            if (imageFile.existsSync()) imageFile.deleteSync();
          }).then((_) => CollectionItemImageTable.delete(id, txn));
        }));
  }

  @override
  Future<void> toggleIsMainImage(
      {ModelID<CollectionItemImage> newMainImageId,
      ModelID<CollectionItemImage> oldMainImageId}) async {
    return init().then((db) => db.transaction((transaction) async {
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

  @override
  Future<void> removeAll(ModelID parent) {
    return init().then((db) => _getItemDirectory(parent)
        .then((dir) => dir.delete(recursive: true))
        .then((_) => CollectionItemImageTable.deleteAll(parent, db)));
  }

  Future<File> _persistImage(File tempFile, ModelID parent) async {
    return _getItemDirectory(parent)
        .then((dir) => "${dir.path}/${p.basename(tempFile.path)}")
        .then((localPath) => tempFile.copy(localPath));
  }

  Future<Directory> _getItemDirectory(ModelID parent) async =>
      getApplicationDocumentsDirectory().then((appDir) =>
          Directory("${appDir.path}/${parent.value}").create(recursive: true));
}
