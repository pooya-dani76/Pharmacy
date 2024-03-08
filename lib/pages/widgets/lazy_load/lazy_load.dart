import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

class LazyLoad {
  List data = [[]];
  int page = 0;
  int paginationBy = 10;
  int? pageNumbers;
  Batch? batch;
  final List<String> sqlCommands;
  Function? afterLoad;

  LazyLoad({
    required this.sqlCommands,
    this.afterLoad,
  }) {
    onInit();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LazyLoad &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(data, other.data);

  @override
  int get hashCode => data.hashCode;

  onInit() async {
    Batch initBatch = await SqliteStorage.createDatabaseBatch();
    initBatch.rawQuery("Select COUNT(*) from (${sqlCommands[0]})");
    List result = await SqliteStorage.commitAll(batch: initBatch);
    pageNumbers = (result.toList()[0][0]['COUNT(*)'] / paginationBy).ceil();
    initBatch = await SqliteStorage.createDatabaseBatch();
    for (var command in sqlCommands) {
      initBatch.rawQuery("$command LIMIT $paginationBy OFFSET ${page * paginationBy}");
      data.add([]);
    }
    data.removeAt(0);
    page++;
    result = await SqliteStorage.commitAll(batch: initBatch);
    for (int index = 0; index < result.length; index++) {
      data[index].addAll(result[index]);
    }
    afterLoad!();
  }

  reload() async {
    data = [[]];
    page = 0;
    paginationBy = 10;
    pageNumbers = null;
    batch = null;
    await onInit();
    afterLoad!();
  }

  load({bool? initLoad = false}) async {
    if (page + 1 <= pageNumbers!) {
      batch = await SqliteStorage.createDatabaseBatch();
      for (var command in sqlCommands) {
        batch!.rawQuery("$command LIMIT $paginationBy OFFSET ${page * paginationBy}");
      }
      List result = await SqliteStorage.commitAll(batch: batch!);
      for (int index = 0; index < result.length; index++) {
        data[index].addAll(result[index]);
      }
      page++;
      afterLoad!();
    } else {}
  }

  Widget listView({required Widget Function(BuildContext, int) itemBuilder}) {
    if (data[0].isEmpty) {
      return const Center(
          child: CustomText(
        text: "موردی ثبت نشده است",
        fontWeight: FontWeight.bold,
      ));
    } else {
      return LazyLoadScrollView(
        child: ListView.builder(
          itemBuilder: itemBuilder,
          itemCount: data[0].length,
          padding: const EdgeInsets.only(bottom: 60),
        ),
        onEndOfPage: () => load(),
      );
    }
  }
}
