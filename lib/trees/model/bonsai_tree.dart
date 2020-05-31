/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import './model_id.dart';
import './species.dart';

/// The development level of a tree.
enum DevelopmentLevel { raw, development, refinement }

// The type of the pot the tree is potted in
enum PotType { nursery_pot, training_pot, bonsai_pot }

/// A bonsai tree.
///
/// Immutable. Instances should be created using the [BonsaiTreeBuilder].
class BonsaiTree {
  // The id of this tree
  final ModelID<BonsaiTree> id;

  /// The (optional) special name of a tree.
  final String treeName;

  /// The species of the tree.
  final Species species;

  /// The orinal of this tree in the species.
  ///
  /// For example if this this is the third 'pinus silvestris' in the collection,
  /// the speicesOrdinal would be 3.
  final int speciesOrdinal;

  /// The development level of the tree.
  final DevelopmentLevel developmentLevel;

  /// The pot type the tree is potted in.
  final PotType potType;

  /// Date the tree was acquired in local time.
  final DateTime acquiredAt;

  /// From whom or where the tree was acquired from.
  final String acquiredFrom;

  BonsaiTree._builder(BonsaiTreeBuilder builder)
      : id = builder._id,
        treeName = builder.treeName,
        species = builder.species,
        speciesOrdinal = builder.speciesOrdinal,
        developmentLevel = builder.developmentLevel,
        potType = builder.potType,
        acquiredAt = builder.acquiredAt,
        acquiredFrom = builder.acquiredFrom;

  /// Gets a nice display name for the tree.
  String get displayName {
    String result = "${species.latinName} $speciesOrdinal";
    if (treeName != null && treeName.isNotEmpty) {
      result += " \'$treeName\'";
    }
    return result;
  }
}

/// Builds an immutable instance of a [BonsaiTree].
class BonsaiTreeBuilder {
  ModelID<BonsaiTree> _id;
  String treeName;
  Species species;
  int speciesOrdinal;
  DevelopmentLevel developmentLevel;
  PotType potType;
  DateTime acquiredAt;
  String acquiredFrom;

  BonsaiTreeBuilder({BonsaiTree fromTree, String id})
      : _id = ModelID<BonsaiTree>.fromID(id) ?? fromTree?.id ?? ModelID<BonsaiTree>.newId(),
        treeName = fromTree?.treeName ?? '',
        species = fromTree?.species ?? Species.unknown,
        speciesOrdinal = fromTree?.speciesOrdinal ?? 1,
        developmentLevel = fromTree?.developmentLevel ?? DevelopmentLevel.raw,
        potType = fromTree?.potType ?? PotType.nursery_pot,
        acquiredAt = fromTree?.acquiredAt ?? DateTime.now(),
        acquiredFrom = fromTree?.acquiredFrom ?? '';

  BonsaiTree build() => BonsaiTree._builder(this);
}
