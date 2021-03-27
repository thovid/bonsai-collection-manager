/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:bonsaicollectionmanager/images/model/collection_item_image.dart';
import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class DummyImageRepository extends ImageRepository {
  List<CollectionItemImage> _images;

  DummyImageRepository({List<CollectionItemImage> images})
      : _images = (images == null ? [] : images);

  @override
  Future<CollectionItemImage> add(
      File imageFile, bool isMainImage, ModelID parent) async {
    var image = (CollectionItemImageBuilder()
          ..fileName = imageFile.path
          ..parentId = parent
          ..isMainImage = isMainImage)
        .build();
    _images.add(image);
    return image;
  }

  @override
  Future<void> remove(ModelID<CollectionItemImage> id) async {
    return;
  }

  @override
  Future<void> toggleIsMainImage(
      {ModelID<CollectionItemImage> newMainImageId,
      ModelID<CollectionItemImage> oldMainImageId}) async {}

  @override
  Future<List<CollectionItemImage>> loadImages(ModelID parent) async {
    return _images;
  }

  @override
  Future<void> removeAll(ModelID parent) async {
    return;
  }
}

class TestSpeciesRepository with SpeciesRepository {
  final Future<List<Species>> species;
  TestSpeciesRepository(this.species);

  @override
  Future<bool> save(Species s) async {
    (await species).add(s);
    return true;
  }
}

class TestBonsaiRepository with BonsaiTreeRepository {
  List<BonsaiTreeData> trees;
  static BonsaiTreeData lastUpdated;
  TestBonsaiRepository(this.trees);

  @override
  Future<BonsaiTreeData> update(BonsaiTreeData tree) async {
    return lastUpdated = tree;
  }

  @override
  Future<List<BonsaiTreeData>> loadBonsaiCollection() async {
    return trees;
  }

  @override
  Future<void> delete(ModelID<BonsaiTreeData> id) async {
    return;
  }
}

class MockLogbookRepository extends Mock implements LogbookRepository {}
