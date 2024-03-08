// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pharmacy/pages/widgets/custom_button.dart';
import 'package:pharmacy/pages/widgets/custom_text_field.dart';
import 'package:pharmacy/pages/widgets/lazy_load/lazy_load.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class CheckBoxSelectorController {
  String query;
  LazyLoad? loader;
  List selecteds = [];
  List selectedIds = [];
  Function afterDone;
  String title;
  Future Function() onAddTap;
  TextEditingController searchController = TextEditingController();

  CheckBoxSelectorController({
    required this.query,
    required this.afterDone,
    required this.title,
    required this.onAddTap,
  });

  List get selectedItems => selecteds;

  setSelecteds(List selectedValues) {
    selecteds = selectedValues;
    selectedIds = selectedValues.map((value) => value['id']).toList();
  }

  addItem(value) {
    selecteds.add(value);
    selectedIds.add(value['id']);
    afterDone();
  }

  removeItem(value) {
    selecteds.removeWhere((element) => element['id'] == value['id']);
    selectedIds.remove(value['id']);
    afterDone();
  }

  searchItems() {}

  openDialog() {
    bool isShowCancelSearch = false;
    Get.defaultDialog(
      title: title,
      content: StatefulBuilder(builder: (context, setState) {
        loader ??=
            LazyLoad(sqlCommands: ["""$query ORDER BY name"""], afterLoad: () => setState(() {}));
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (isShowCancelSearch) ...{
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        isShowCancelSearch = false;
                        loader = LazyLoad(
                            sqlCommands: ["""$query ORDER BY name"""],
                            afterLoad: () => setState(() {}));
                      },
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 10),
                  },
                  Expanded(
                    child: CustomTextField(
                      controller: searchController,
                      onChanged: (value) => Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          if (searchController.text == value) {
                            isShowCancelSearch = true;
                            loader = LazyLoad(
                                sqlCommands: ['$query Where name Like "%$value%" ORDER BY name'],
                                afterLoad: () => setState(() {}));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  flex: 10,
                  child: loader!.listView(
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: selectedIds.contains(loader!.data[0][index]['id']),
                        secondary: InkWell(
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                            ),
                            onTap: () {
                              if (query.contains("DrugCategories")) {
                                routeToPage(
                                        page: Routes.editCategoryPage,
                                        arguments: {"category": loader!.data[0][index]})
                                    .whenComplete(() => setState(() {
                                          loader = LazyLoad(
                                              sqlCommands: ["""$query ORDER BY name"""],
                                              afterLoad: () => setState(() {}));
                                        }));
                              } else {
                                routeToPage(
                                        page: Routes.editShapePage,
                                        arguments: {"shape": loader!.data[0][index]})
                                    .whenComplete(() => setState(() {
                                          loader = LazyLoad(
                                              sqlCommands: ["""$query ORDER BY name"""],
                                              afterLoad: () => setState(() {}));
                                        }));
                              }
                            }),
                        onChanged: (value) {
                          if (value!) {
                            addItem(loader!.data[0][index]);
                          } else {
                            removeItem(loader!.data[0][index]);
                          }
                          setState(() {});
                        },
                        title: CustomText(text: loader!.data[0][index]['name']),
                      );
                    },
                  )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "تایید",
                      onTap: () => Get.back(),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      title: "افزودن  +",
                      onTap: () async => await onAddTap().whenComplete(() => setState(() {
                            loader =
                                LazyLoad(sqlCommands: ["""$query ORDER BY name"""], afterLoad: () => setState(() {}));
                          })),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
