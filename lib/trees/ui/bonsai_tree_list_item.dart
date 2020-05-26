/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:flutter/material.dart';

import '../model/bonsai_tree.dart';

class BonsaiTreeListItem extends StatelessWidget {
  final BonsaiTree tree;
  final Function onTap;
  BonsaiTreeListItem({this.tree, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ExcludeSemantics(child: CircleAvatar()),
      title: Text(tree.displayName),
      onTap: onTap,
    );
  }
}
