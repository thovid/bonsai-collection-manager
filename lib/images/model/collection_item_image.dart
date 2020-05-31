/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';

class CollectionItemImage {
  final ModelID<CollectionItemImage> id;
  final ModelID parentId;
  final String fileName;

  CollectionItemImage._builder(CollectionItemImageBuilder builder)
      : id = builder._id,
        parentId = builder.parentId,
        fileName = builder.fileName;
}

class CollectionItemImageBuilder {
  ModelID<CollectionItemImage> _id;
  ModelID parentId;
  String fileName;

  CollectionItemImageBuilder({CollectionItemImage fromImage, String id})
      : _id = ModelID<CollectionItemImage>.fromID(id) ??
            fromImage?.id ??
            ModelID<CollectionItemImage>.newId(),
        parentId = fromImage?.parentId,
        fileName = fromImage?.fileName;

  CollectionItemImage build() => CollectionItemImage._builder(this);
}
