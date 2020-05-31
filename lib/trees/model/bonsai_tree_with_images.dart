/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/image_gallery_model.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:flutter/widgets.dart';

import 'bonsai_tree.dart';

class BonsaiTreeWithImages with ChangeNotifier {
  final BonsaiCollection _collection;
  BonsaiTree tree;
  ImageGalleryModel images;

  BonsaiTreeWithImages({@required this.tree, this.images, @required BonsaiCollection collection})
      : _collection = collection;

  Future<BonsaiTree> updateTree(BonsaiTree tree) async {
    return _collection
        .update(tree)
        .then((updatedTree) => this.tree = updatedTree)
        .then((updatedTree) {
      notifyListeners();
      return updatedTree;
    });
  }
}
