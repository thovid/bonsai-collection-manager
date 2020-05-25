/*
 * Copyright (c) 2020 by Thomas Vidic
 */

// the development level of a tree
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:uuid/uuid.dart';

/// The development level of a tree.
enum DevelopmentLevel { raw, development, refinement }

// The type of the pot the tree is potted in
enum PotType { nursery_pot, training_pot, bonsai_pot }

// ID type for a bonsai tree
class BonsaiTreeID {
  static final uuid = Uuid();
  final String _id;

  BonsaiTreeID(this._id);
  BonsaiTreeID.newId() : this(uuid.v4());

  String get id => _id;

  @override
  operator ==(other) => _id == other._id;
  @override
  int get hashCode => _id.hashCode;
}

/// A bonsai tree.
///
/// Immutable. Instances should be created using the [BonsaiTreeBuilder].
class BonsaiTree {
  // The id of this tree
  final BonsaiTreeID id;

  /// The (optional) special name of a tree.
  final String treeName;

  /// The species of the tree.
  final Species species;

  /// The counter of this tree in the species.
  ///
  /// For example if this this is the third 'pinus silvestris' in the collection,
  /// the speicesCounter would be 3.
  final int speciesCounter;

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
        speciesCounter = builder.speciesCounter,
        developmentLevel = builder.developmentLevel,
        potType = builder.potType,
        acquiredAt = builder.acquiredAt,
        acquiredFrom = builder.acquiredFrom;

  /// Gets a nice display name for the tree.
  String get displayName {
    String result = "${species.latinName} $speciesCounter";
    if (treeName != null && treeName.isNotEmpty) {
      result += " \'$treeName\'";
    }
    return result;
  }
}

/// Builds an immutable instance of a [BonsaiTree].
class BonsaiTreeBuilder {
  BonsaiTreeID _id;
  String treeName;
  Species species;
  int speciesCounter;
  DevelopmentLevel developmentLevel;
  PotType potType;
  DateTime acquiredAt;
  String acquiredFrom;

  BonsaiTreeBuilder({BonsaiTree fromTree})
      : _id = fromTree?.id ?? BonsaiTreeID.newId(),
        treeName = fromTree?.treeName ?? '',
        species = fromTree?.species ?? Species.unknown,
        speciesCounter = fromTree?.speciesCounter ?? 1,
        developmentLevel = fromTree?.developmentLevel ?? DevelopmentLevel.raw,
        potType = fromTree?.potType ?? PotType.nursery_pot,
        acquiredAt = fromTree?.acquiredAt ?? DateTime.now(),
        acquiredFrom = fromTree?.acquiredFrom ?? '';

  BonsaiTree build() {
    return BonsaiTree._builder(this);
  }
}
