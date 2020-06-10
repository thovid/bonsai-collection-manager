/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../../images/model/images.dart';
import '../../shared/model/model_id.dart';

abstract class LogbookRepository {
  Future<List<LogbookEntry>> loadLogbook(ModelID subjectId);
  Future<void> add(LogbookEntry logbookEntry, ModelID subjectId);
  Future<void> update(LogbookEntry logbookEntry, ModelID subjectId);
  Future<void> delete(ModelID<LogbookEntry> id);
}

class Logbook with ChangeNotifier {
  final LogbookRepository _logbookRepository;
  final ImageRepository _imageRepository;
  final ModelID _subjectId;
  final List<LogbookEntryWithImages> _entries;

  Logbook._internal(
      {@required ModelID subjectId,
      @required LogbookRepository logbookRepository,
      @required ImageRepository imageRepository})
      : _logbookRepository = logbookRepository,
        _imageRepository = imageRepository,
        _subjectId = subjectId,
        _entries = <LogbookEntryWithImages>[];

  static Future<Logbook> load(
      {@required LogbookRepository logbookRepository,
      @required ImageRepository imageRepository,
      @required ModelID subjectId}) async {
    final Logbook result = Logbook._internal(
        logbookRepository: logbookRepository,
        imageRepository: imageRepository,
        subjectId: subjectId);
    List<LogbookEntry> entries = await logbookRepository.loadLogbook(subjectId);
    entries.forEach((entry) {
      result._entries.add(LogbookEntryWithImages(
          entry: entry,
          images: Images(repository: imageRepository, parent: subjectId)));
    });
    return result;
  }

  int get length => _entries.length;

  List<LogbookEntryWithImages> get entries => List.unmodifiable(_entries);

  Future<LogbookEntryWithImages> add(LogbookEntry logbookEntry) async {
    LogbookEntryWithImages entryWithImages = LogbookEntryWithImages(
        entry: logbookEntry,
        images: Images(repository: _imageRepository, parent: logbookEntry.id));
    return await _insert(entryWithImages);
  }

  LogbookEntryWithImages findById(ModelID<LogbookEntry> id) =>
      _entries.firstWhere((element) => element.id == id, orElse: () => null);

  Future<LogbookEntryWithImages> update(
      LogbookEntryWithImages entryWithImages) async {
    final int index =
        _entries.indexWhere((element) => element.id == entryWithImages.id);
    if (index < 0) {
      return _insert(entryWithImages);
    }

    _entries[index] = entryWithImages;
    await _logbookRepository.update(entryWithImages.entry, _subjectId);
    return entryWithImages;
  }

  Future<void> delete(ModelID<LogbookEntry> id) async {
    await _logbookRepository.delete(id);
    _entries.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<LogbookEntryWithImages> _insert(
      LogbookEntryWithImages entryWithImages) async {
    await _logbookRepository.add(entryWithImages.entry, _subjectId);
    _entries.add(entryWithImages);
    notifyListeners();
    return entryWithImages;
  }
}

class LogbookEntry {
  final ModelID<LogbookEntry> id;
  final LogWorkType workType;
  final String workTypeName;
  final DateTime date;
  final String notes;

  LogbookEntry._builder(LogbookEntryBuilder builder)
      : id = builder._id,
        workType = builder.workType,
        workTypeName = builder.workTypeName,
        date = builder.date,
        notes = builder.notes;
}

class LogbookEntryBuilder {
  final ModelID<LogbookEntry> _id;
  LogWorkType workType;
  String workTypeName;
  DateTime date;
  String notes;

  LogbookEntryBuilder({LogbookEntry fromEntry, String id})
      : _id = ModelID<LogbookEntry>.fromID(id) ??
            fromEntry?.id ??
            ModelID<LogbookEntry>.newId(),
        workType = fromEntry?.workType ?? LogWorkType.custom,
        date = fromEntry?.date ?? DateTime.now(),
        workTypeName = fromEntry?.workTypeName,
        notes = fromEntry?.notes;

  LogbookEntry build() {
    return LogbookEntry._builder(this);
  }
}

class LogbookEntryWithImages with ChangeNotifier {
  LogbookEntry _entry;
  Images images;

  LogbookEntryWithImages(
      {@required LogbookEntry entry, @required this.images})
      : _entry = entry{
    images.addListener(() {
      notifyListeners();
    });
  }

  bool get imagesFetched => images.imagesFetched;

  ModelID<LogbookEntry> get id => _entry.id;

  LogbookEntry get entry => _entry;

  set entry(LogbookEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  Future<LogbookEntryWithImages> fetchImages() async {
    await images.fetchImages();
    return this;
  }
}

enum LogWorkType {
  watered,
  fertilized,
  sprayed,
  wired,
  deadwood,
  pruned,
  repotted,
  custom,
  pinched,
}
