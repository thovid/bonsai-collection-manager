/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../model/species.dart';
import '../model/bonsai_collection.dart';
import '../model/bonsai_tree_data.dart';

import '../../shared/infrastructure/base_repository.dart';
import './bonsai_tree_table.dart';

class SQLBonsaiTreeRepository extends BaseRepository with BonsaiTreeRepository {

  final SpeciesRepository speciesRepository;
  SQLBonsaiTreeRepository(this.speciesRepository);

  @override
  Future<BonsaiCollection> loadCollection() =>
      init().then((db) async => BonsaiCollection.withTrees(
          await BonsaiTreeTable.readAll(speciesRepository, db),
          repository: this));

  @override
  Future<void> update(BonsaiTreeData tree) async =>
      init().then((db) => BonsaiTreeTable.write(tree, db));

}
