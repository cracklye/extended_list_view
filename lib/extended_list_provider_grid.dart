import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewLayoutGrid<T> extends ListViewLayoutDefault<T> {
  ListViewLayoutGrid(
      {super.enableSearch,
      super.enableSorting,
      super.key = "list_grid",
      super.builder,
      required super.selectIcon})
      : super(
            getSizeParameters: () =>
                SizeParameters(7, 2, (value) => value.toString()));
  @override
  Widget buildContent(
      BuildContext context, List<T> items, ExtendedListContext<T> listContext) {
    return GridView.count(
      crossAxisCount: 5,
      // shrinkWrap: true,
      children: items
          .map((e) => buildGridItemDefault(context, e, listContext))
          .toList(),
    );
  }

  Widget buildGridItemDefault(
      BuildContext context, T item, ExtendedListContext<T> listContext) {
    var isSelected = listContext.isSelected(item);

    if (builder != null) {
      return builder!(context, listContext, item, isSelected);
    }
    return buildContentItemGestureDetector(context, item, listContext,
        buildContentItem(context, item, listContext));
  }

  Widget buildContentItem(
      BuildContext context, T item, ExtendedListContext<T> listContext) {
    var isSelected = listContext.isSelected(item);

    return Padding(
        padding: EdgeInsets.all(10),
        child: GridTile(
          // header: GestureDetector(
          //   onTap: () {
          //     if (onTap != null) {
          //       onTap!(item);
          //     }
          //   },
          //   onDoubleTap: () {
          //     if (onDoubleTap != null) {
          //       onDoubleTap!(item);
          //     }
          //   },
          footer: GridTileBar(
            title: Text(item.toString()),
            backgroundColor: isSelected ? Colors.red : Colors.black45,
          ),

          child: CircleAvatar(
              // backgroundColor: isSelected ? Colors.red : Colors.amber[100],
              child: Text(getInitials(item.toString()))),
        )
        // Text(
        //   item.toString(),
        //   softWrap: true,
        //   //overflow: TextOverflow.Wrap,
        // )
        );
  }

  String getInitials(String label) => label.isNotEmpty
      ? label.trim().split(RegExp(' +')).map((s) => s[0]).take(4).join()
      : '';
}
