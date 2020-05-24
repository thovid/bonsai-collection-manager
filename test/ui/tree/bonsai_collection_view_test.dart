import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_collection_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Shows tree from collection', (WidgetTester tester) async {
    BonsaiCollection collection = BonsaiCollection.withTrees([
      (BonsaiTreeBuilder()
            ..treeName = "My Tree"
            ..species = Species(TreeType.conifer, latinName: "Testus Treeus"))
          .build()
    ]);

    await tester.pumpWidget(testAppWith(BonsaiCollectionView(collection)));
    expect(find.text('Testus Treeus 1 \'My Tree\''), findsOneWidget);
  });
}
