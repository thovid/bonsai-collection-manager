/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:flutter/widgets.dart';

import 'bonsai_tree_data.dart';

class BonsaiTreeWithImages with ChangeNotifier {
  BonsaiTreeData _treeData;
  Images images;

  BonsaiTreeWithImages({@required BonsaiTreeData treeData, this.images})
      : _treeData = treeData;

  set treeData(BonsaiTreeData data) {
    treeData = data;
    notifyListeners();
  }

  BonsaiTreeData get treeData => _treeData;
}
