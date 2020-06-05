/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/widgets.dart';

import '../../images/model/images.dart';
import '../../shared/model/model_id.dart';
import './bonsai_tree_data.dart';

class BonsaiTreeWithImages with ChangeNotifier {
  BonsaiTreeData _treeData;
  Images images;

  BonsaiTreeWithImages({@required BonsaiTreeData treeData, this.images})
      : _treeData = treeData {
    images.addListener(() {
      this.notifyListeners();
    });
  }

  bool get imagesFetched => images.imagesFetched;

  set treeData(BonsaiTreeData data) {
    _treeData = data;
    notifyListeners();
  }

  BonsaiTreeData get treeData => _treeData;

  ModelID<BonsaiTreeData> get id => _treeData.id;

  String get displayName => _treeData.displayName;

  Future<BonsaiTreeWithImages> fetchImages() async {
    await images.fetchImages();
    return this;
  }
}
