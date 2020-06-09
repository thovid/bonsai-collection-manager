/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/ui/spaces.dart';
import 'package:flutter/material.dart';

import '../../credits/ui/credits_page.dart';
import '../../trees/ui/view_bonsai_collection_page.dart';
import '../i18n/app_drawer.i18n.dart';

Drawer buildAppDrawer(
        {@required BuildContext context, @required String currentPage}) =>
    Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.white10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image(
                              image: AssetImage("icons/bonsai.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          smallVerticalSpace,
                          Text(
                            "Bonsai Collection Manager",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ])),
              ),
              _buildDrawerItem(
                  icon: ImageIcon(AssetImage('icons/bonsai.png')),
                  context: context,
                  targetRoute: ViewBonsaiCollectionPage.route_name,
                  title: "My collection".i18n,
                  currentRoute: currentPage),
              Divider(
                color: Colors.black54,
              ),
              AboutListTile(
                icon: Icon(Icons.help),
                applicationIcon: ImageIcon(AssetImage('icons/bonsai.png')),
                applicationName: 'Bonsai Collection Manager',
                applicationVersion: '1.0.0',
                applicationLegalese: '© Thomas Vidic',
                aboutBoxChildren: <Widget>[Text(aboutText.i18n)],
              ),
              _buildDrawerItem(
                  context: context,
                  icon: Icon(Icons.info),
                  targetRoute: CreditsPage.route_name,
                  title: 'Credits',
                  currentRoute: currentPage,
                  pushOnStack: true),
            ],
          ),
        ),
      ),
    );

Widget _buildDrawerItem(
    {@required BuildContext context,
    @required String targetRoute,
    Widget icon,
    @required String title,
    @required String currentRoute,
    bool pushOnStack = false}) {
  final bool isSelected = targetRoute == currentRoute;

  return Container(
      color: isSelected ? Theme.of(context).primaryColor : null,
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop();
          if (!isSelected) {
            if (pushOnStack)
              Navigator.of(context).pushNamed(targetRoute);
            else
              Navigator.of(context).pushReplacementNamed(targetRoute);
          }
        },
      ));
}
