/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';

class CollectionItemImage {
  final ModelID<CollectionItemImage> id;
  final ModelID parentId;
  final String fileName;
  final bool isMainImage;

  CollectionItemImage._builder(CollectionItemImageBuilder builder)
      : id = builder._id,
        parentId = builder.parentId,
        fileName = builder.fileName,
        isMainImage = builder.isMainImage;
}

class CollectionItemImageBuilder {
  ModelID<CollectionItemImage> _id;
  ModelID parentId;
  String fileName;
  bool isMainImage = false;

  CollectionItemImageBuilder({CollectionItemImage fromImage, String id})
      : _id = ModelID<CollectionItemImage>.fromID(id) ??
            fromImage?.id ??
            ModelID<CollectionItemImage>.newId(),
        parentId = fromImage?.parentId,
        fileName = fromImage?.fileName,
        isMainImage = fromImage?.isMainImage ?? false;

  CollectionItemImage build() => CollectionItemImage._builder(this);
}
