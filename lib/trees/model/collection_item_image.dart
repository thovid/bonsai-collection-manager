/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import './bonsai_tree.dart';
import './model_id.dart';

class CollectionItemImage {
  final ModelID<CollectionItemImage> id;
  final ModelID<BonsaiTree> parentId;
  final String fileName;

  CollectionItemImage._builder(CollectionItemImageBuilder builder)
      : id = builder._id,
        parentId = builder.parentId,
        fileName = builder.fileName;
}

class CollectionItemImageBuilder {
  ModelID<CollectionItemImage> _id;
  ModelID<BonsaiTree> parentId;
  String fileName;

  CollectionItemImageBuilder({CollectionItemImage fromImage, String id})
      : _id = ModelID<CollectionItemImage>.fromID(id) ??
            fromImage?.id ??
            ModelID<CollectionItemImage>.newId(),
        parentId = fromImage?.parentId,
        fileName = fromImage?.fileName;

  CollectionItemImage build() => CollectionItemImage._builder(this);
}
