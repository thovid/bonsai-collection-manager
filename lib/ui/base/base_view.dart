import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin Screen<T extends ChangeNotifier> {
  Widget build(BuildContext context) => _BaseScreenProvider<T>(
      initializer: initialModel,
      builder: (context, model, _) => SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: Text(title(context, model)),
            ),
            body: body(context, model),
            floatingActionButton: floatingActionButton(context, model),
          )));

  T initialModel(BuildContext context);
  String title(BuildContext context, T model);
  Widget body(BuildContext context, T model);
  Widget floatingActionButton(BuildContext context, T model);
}

class _BaseScreenProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T Function(BuildContext context) initializer;
  final Widget Function(BuildContext context, T model, Widget child) builder;

  _BaseScreenProvider({this.initializer, this.builder});

  @override
  _BaseScreenProviderState createState() => _BaseScreenProviderState<T>();
}

class _BaseScreenProviderState<T extends ChangeNotifier>
    extends State<_BaseScreenProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: widget.initializer(context),
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
