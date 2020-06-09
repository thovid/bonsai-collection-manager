/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/ui/spaces.dart';

class CreditsPage extends StatelessWidget {
  static const route_name = '/credits';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Credits"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mediumVerticalSpace,
              RichText(
                text: _p([
                  _t("Made with flutter: "),
                  _l("www.flutter.dev", url: "http://www.flutter.dev"),
                ]),
              ),
              mediumVerticalSpace,
              RichText(
                text: _p([
                  _t("App icon made by "),
                  _l("Nikita Golubev ",
                      url:
                          "https://www.flaticon.com/de/kostenloses-icon/bonsai_362578"),
                  _t("from "),
                  _l("www.flaticon.com", url: "https://www.flaticon.com"),
                ]),
              ),
              mediumVerticalSpace,
              RichText(
                text: _p([
                  _t("Tree type icons made by "),
                  _l("Freepik ", url: "https://www.flaticon.com/authors/freepik"),
                  _t("from "),
                  _l("www.flaticon.com", url: "https://flaticon.com")
                ]),
              ),
            ],
          ),
        ),
      );

  _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  TextSpan _p(List<TextSpan> children) => TextSpan(children: children);
  TextSpan _t(String text) =>
      TextSpan(text: text, style: TextStyle(color: Colors.black, fontSize: 18));
  TextSpan _l(String text, {String url}) => TextSpan(
        text: text,
        style: TextStyle(color: Colors.blueAccent, fontSize: 18),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _openUrl(url);
          },
      );
}
