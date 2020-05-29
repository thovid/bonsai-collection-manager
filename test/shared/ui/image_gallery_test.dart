/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:io';

import 'package:bonsaicollectionmanager/shared/ui/image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

const String image_path = 'an_image_path.jpg';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/image_picker');

  final List<MethodCall> log = <MethodCall>[];
  String pathToReturn;
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      return pathToReturn;
    });

    log.clear();
  });

  testWidgets('can open view with empty gallery', (WidgetTester tester) async {
    var model = ImageGalleryModel();
    await _startViewWith(model, tester);
    expect(find.text("Add your first image"), findsOneWidget);
  });

  testWidgets('can take photo from camera and add it to images',
      (WidgetTester tester) async {
    pathToReturn = image_path;
    var model = ImageGalleryModel();

    await _startViewWith(model, tester)
        .then((_) => _tapMenuButton(tester, _openCameraButton()));

    expect(model.images.length, equals(1));
    expect(model.images[0].path, equals(image_path));
  });

  testWidgets('shows tiles for images in gallery', (WidgetTester tester) async {
    var model = ImageGalleryModel()
      ..addImage(File('some_path.jpg'))
      ..addImage(File('some__other_path.jpg'));
    await _startViewWith(model, tester);
    expect(find.byType(ImageTile), findsNWidgets(2));
  });

  testWidgets('can handle no photo taken via camera',
      (WidgetTester tester) async {
    pathToReturn = null;
    var model = ImageGalleryModel();

    await _startViewWith(model, tester)
        .then((_) => _tapMenuButton(tester, _openCameraButton()));

    expect(model.images.length, equals(0));
  });

  testWidgets('can take photo from gallery and add it to images',
      (WidgetTester tester) async {
    pathToReturn = image_path;
    var model = ImageGalleryModel();

    await _startViewWith(model, tester)
        .then((_) => _tapMenuButton(tester, _openGalleryButton()));

    expect(model.images.length, equals(1));
    expect(model.images[0].path, equals(image_path));
  });

  testWidgets('can handle no photo taken from gallery',
      (WidgetTester tester) async {
    pathToReturn = null;
    var model = ImageGalleryModel();

    await _startViewWith(model, tester)
        .then((_) => _tapMenuButton(tester, _openGalleryButton()));

    expect(model.images.length, equals(0));
  });

  testWidgets(
      'main image does no longer show add image hint after first image was selected',
      (WidgetTester tester) async {
    pathToReturn = image_path;
    var model = ImageGalleryModel();

    await _startViewWith(model, tester)
        .then((_) => _tapMenuButton(tester, _openGalleryButton()));
    expect(find.text("Add your first image"), findsNothing);
  });

  // TODO test is skipped because due to some unknown reason the tap does not work
  testWidgets('opens image from gallery on tap onto gallery image',
      (WidgetTester tester) async {
    var model = ImageGalleryModel()..addImage(File('some_image.jpg'));
    await _startViewWith(model, tester);
    await tester
        .tap(find.byType(ImageTile))
        .then((_) => tester.pumpAndSettle());

    expect(find.byType(ImagePopup), findsOneWidget);
  }, skip: true);

  testWidgets('opens image from gallery on tap onto main image',
      (WidgetTester tester) async {
    var model = ImageGalleryModel()..addImage(File('some_path.jpg'));
    await _startViewWith(model, tester)
        .then((_) => tester.tap(find.byType(MainImageTile)))
        .then((_) => tester.pumpAndSettle());

    expect(find.byType(ImagePopup), findsOneWidget);
  });

  testWidgets('can toggle main image in image popup',
      (WidgetTester tester) async {
    var model = ImageGalleryModel()..addImage(File('firstImage.jpg'));
    var secondImage = model.addImage(File('secondImage.jpg'));

    await _startViewWith(model, tester)
        .then((_) => tester.tap(find.byType(MainImageTile)))
        .then((_) => tester.pumpAndSettle());

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
    await tester.tap(find.byIcon(Icons.favorite)).then((_) => tester.pump());
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(model.primaryImage, equals(secondImage));
  });

  testWidgets('can delete images', (WidgetTester tester) async {
    var model = ImageGalleryModel()..addImage(File('firstImage.jpg'));
    var secondImage = model.addImage(File('secondImage.jpg'));
    await _startViewWith(model, tester)
        .then((_) => tester.tap(find.byType(MainImageTile)))
        .then((_) => tester.pumpAndSettle())
        .then((_) => tester.tap(find.byIcon(Icons.delete)))
        .then((_) => tester.pump());
    expect(model.images.length, equals(1));
    expect(find.byType(ImageTile), findsNWidgets(1));
    expect(model.primaryImage, equals(secondImage));

    await tester.tap(find.byType(MainImageTile))
        .then((_) => tester.pumpAndSettle())
        .then((_) => tester.tap(find.byIcon(Icons.delete)))
        .then((_) => tester.pump());
    expect(model.images.length, equals(0));
    expect(find.byType(ImageTile), findsNothing);
    expect(find.text("Add your first image"), findsOneWidget);
  });

}

Future<dynamic> _tapMenuButton(WidgetTester tester, Finder button) async {
  return tester
      .tap(_openMenuButton())
      .then((value) => tester.pumpAndSettle())
      .then((value) => tester.tap(button))
      .then((value) => tester.pump());
}

Finder _openCameraButton() => find.byIcon(Icons.add_a_photo);

Finder _openGalleryButton() => find.byIcon(Icons.add_photo_alternate);

Finder _openMenuButton() {
  return find.byWidgetPredicate(
      (widget) => (widget is FlatButton && widget.child is AnimatedIcon));
}

Future _startViewWith(ImageGalleryModel model, WidgetTester tester) async {
  var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
  var app = testAppWith(
      ChangeNotifierProvider<ImageGalleryModel>.value(
        value: model,
        builder: (context, child) => ImageGallery(),
      ),
      collection);

  await tester.pumpWidget(app);
}
