import 'package:extended_list_view/context_menu.dart';
import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Stores the parameters for the size slider
class SizeParameters {
  SizeParameters(this.max, this.min, this.getLabel);
  final double max;
  final double min;
  final String Function(double value)? getLabel;
}

typedef ExtendedListItemBuilder<T> = Widget Function(BuildContext context,
    ExtendedListContext<T> listContext, T item, bool isSelected);

abstract class ListViewLayoutProvider<T> {
  /// If this function is provided then the size slider will be shown based on the values
  SizeParameters Function()? getSizeParameters;

  /// Whether to show the sort option (if its provided)
  bool get enableSorting;

  // Whether to show the search bar, false will not show it, true will show it, and null will use the user settings
  bool? get enableSearch;

  // This widget will be inserted under the toolbar but above the main content
  Widget Function(BuildContext buildContext)? buildToolbarSub;

  Widget Function(BuildContext buildContext)? buildToolbarFooter;

  

  Widget Function()? buildLoadingContent;
  Widget Function()? buildNoContent;
  Widget buildContent(
      BuildContext context, List<T> items, ExtendedListContext<T> listContext);

  IconData get selectIcon;
  String get selectLabel;
  bool get enabled;
  bool get visible;
  String get key;

  ExtendedListItemBuilder<T>? get builder;
}

abstract class ListViewLayoutDefault<T> extends ListViewLayoutProvider<T> {
  ListViewLayoutDefault({
    required this.selectIcon,
    required this.key,
    this.selectLabel = "",
    this.visible = true,
    this.enabled = true,
    this.enableSearch = true,
    this.enableSorting = true,
    this.getSizeParameters,
    this.builder,
  });
  @override
  final ExtendedListItemBuilder<T>? builder;
  @override
  SizeParameters Function()? getSizeParameters;
  @override

  /// Whether to show the sort option (if its provided)
  final bool enableSorting;
  @override
  // Whether to show the search bar, false will not show it, true will show it, and null will use the user settings
  final bool? enableSearch;
  @override
  final bool enabled;
  @override
  final bool visible;
  @override
  final IconData selectIcon;
  @override
  final String selectLabel;
  @override
  final String key;
  @override

  // This widget will be inserted under the toolbar but above the main content
  //Widget Function(BuildContext buildContext)? buildToolbarSub;

  @override
  Widget Function()? get buildLoadingContent => _buildLoadingContent;

  
  Widget _buildLoadingContent() {
    return const Center(
        child:
            Column(children: [CircularProgressIndicator(), Text("Loading")]));
  }

  @override
  Widget Function()? get buildNoContent => _buildNoContent;

  Widget _buildNoContent() {
    return const Text("No items available");
  }

  @override
  Widget buildContent(
      BuildContext context, List<T> items, ExtendedListContext<T> listContext) {
    return Text("The buildContent method needs to be overridden $items");
  }

  Widget buildContentItemGestureDetector(BuildContext context, T item,
      ExtendedListContext<T> listContext, Widget child, int index) {
    if (listContext.contextMenuBuilder != null) {
      return ContextMenuRegion<T>(
          contextMenuController: listContext.contextMenuController!,
          contextMenuBuilder: listContext.contextMenuBuilder!,
          item: item,
          child: _buildGesture(context, item, listContext, child));
    } else {
      return _buildGesture(context, item, listContext, child);
    }
  }

  Widget buildAutoScroll(BuildContext context, T item,
      ExtendedListContext<T> listContext, Widget child, int index) {
    if (listContext.autoScrollController == null) {
      return child;
    }
    return AutoScrollTag(
        key: ValueKey(index),
        controller: listContext.autoScrollController!,
        index: index,
        child: child);
  }

  Widget _buildGesture(BuildContext context, T item,
      ExtendedListContext<T> listContext, Widget child) {
    return GestureDetector(
        onTap: _onTap(item, listContext),
        onDoubleTap: listContext.onDoubleTap == null
            ? null
            : () => listContext.onDoubleTap!(item),
        onLongPress: listContext.onLongTap == null
            ? null
            : () => listContext.onLongTap!(item),
        child: child);
  }

  Function()? _onTap(
    T item,
    ExtendedListContext<T> listContext,
  ) {
    return () {
      if (listContext.contextMenuIsShown()) {
        listContext.contextMenuClear();
      } else if (listContext.onTap == null) {
        // return null;
      } else {
        listContext.onTap!(item);
      }
    };
  }
}
