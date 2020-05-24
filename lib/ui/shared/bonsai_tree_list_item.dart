import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:flutter/material.dart';

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
