import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewLayoutGallery<T> extends ListViewLayoutDefault<T> {
  final double height;
  ListViewLayoutGallery(
      {super.enableSearch,
      super.enableSorting,
      super.key = "list_gallery",
      super.builder,
      this.height = 200,
      required super.selectIcon});

  @override
  Widget buildContent(
      BuildContext context, List<T> items, ExtendedListContext<T> listContext) {
    return SizedBox.fromSize(
        size: Size(double.infinity, height),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
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
        ));
  }

  Widget buildContentItem(BuildContext context, T item,
      ExtendedListContext<T> listContext, int index) {
    var isSelected = listContext.isSelected(item);

    return SizedBox.fromSize(
        size: Size(height, height),
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Container(
                color: Colors.red,
                child: ListTile(
                  selected: isSelected,
                  title: Text(item.toString()),
                  //);
                ))));
  }
}
