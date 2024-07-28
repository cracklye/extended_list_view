import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewLayoutList<T> extends ListViewLayoutDefault<T> {
  ListViewLayoutList(
      {super.enableSearch,
      super.enableSorting,
      super.key = "list_view",
      super.builder,
      required super.selectIcon});

  @override
  Widget buildContent(
      BuildContext context, List<T> items, ExtendedListContext<T> listContext) {
    return ListView.builder(
      controller: listContext.autoScrollController,
      itemBuilder: (context, index) {
        var item = items[index];
        var isSelected = listContext.isSelected(item);

        if (builder != null) {
          return builder!(context, listContext, item, isSelected);
        }
        return buildAutoScroll(
            context,
            item,
            listContext,
            buildContentItemGestureDetector(context, item, listContext,
                buildContentItem(context, item, listContext, index), index),
            index);
      },
      itemCount: items.length,
    );
  }

  Widget buildContentItem(BuildContext context, T item,
      ExtendedListContext<T> listContext, int index) {
    var isSelected = listContext.isSelected(item);

    return ListTile(
      selected: isSelected,
      title: Text(item.toString()),
      //);
    );
  }
}
