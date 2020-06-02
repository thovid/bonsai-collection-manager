/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../../shared/infrastructure/base_repository.dart';

import '../model/species.dart';
import '../model/bonsai_tree_data.dart';
import '../model/bonsai_tree_collection.dart';
import './bonsai_tree_table.dart';

class SQLBonsaiTreeRepository extends BaseRepository with BonsaiTreeRepository {
  final SpeciesRepository speciesRepository;
  SQLBonsaiTreeRepository(this.speciesRepository);

  @override
  Future<void> update(BonsaiTreeData tree) async =>
      init().then((db) => BonsaiTreeTable.write(tree, db));

  @override
  Future<List<BonsaiTreeData>> loadBonsaiCollection() =>
      init().then((db) => BonsaiTreeTable.readAll(speciesRepository, db));
}
