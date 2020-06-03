/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../../trees/ui/view_bonsai_collection_page.dart';
import '../i18n/app_drawer.i18n.dart';

Drawer buildAppDrawer(
        {@required BuildContext context, @required String currentPage}) =>
    Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _buildDrawerItem(
                  context: context,
                  targetRoute: ViewBonsaiCollectionPage.route_name,
                  title: "My collection".i18n,
                  currentRoute: currentPage),
              AboutListTile(
                //applicationIcon: TODO
                applicationName: 'Bonsai Collection Manager',
                applicationVersion: '1.0.0',
                applicationLegalese: '© Thomas Vidic',
              )
            ],
          ),
        ),
      ),
    );

Widget _buildDrawerItem(
    {@required BuildContext context,
    @required String targetRoute,
    Icon icon,
    @required String title,
    @required String currentRoute}) {
  final bool isSelected = targetRoute == currentRoute;

  return Container(
      color: isSelected ? Theme.of(context).primaryColor : null,
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop();
          if (!isSelected) Navigator.of(context).pushNamed(targetRoute);
        },
      ));
}
