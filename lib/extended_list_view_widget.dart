import 'package:extended_list_view/extended_list_view.dart';
import 'package:extended_list_view/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// enum ListViewType {
//   tree,
//   list,
//   grid,
//   table,
//   sortable,
//   map,
// }

//abstract class ListDataProvider {}

abstract class ListViewSortOrderBy {
  String get key;
}

class ListViewSortOrderByFieldName extends ListViewSortOrderBy {
  final String fieldName;
  final bool ascending;
  @override
  final String key;

  ListViewSortOrderByFieldName(this.key, this.fieldName, this.ascending);
}

abstract class ListViewFilter<T> {
  String get key;
}

enum FilterComparison { equals, notequals, like, greaterthan, lessthan, isin }

class ListViewFilterField<T> extends ListViewFilter<T> {
  final dynamic value;
  final String fieldName;
  @override
  final String key;
  final bool isString;
  final String label;

  final FilterComparison comparison;
  ListViewFilterField(this.key, this.fieldName, this.value, this.comparison,
      this.isString, this.label);
}

class ListViewOrderByItem {
  final String label;
  final dynamic value;
  ListViewOrderByItem({required this.label, this.value});
}

class ListViewFilterByItem {
  final String label;
  final dynamic value;
  ListViewFilterByItem({required this.label, this.value});
}

class ExtendedListContext<T> {
  ExtendedListContext(
      {this.onDoubleTap,
      this.onTap,
      this.onLongTap,
      this.onReorder,
      this.selected,
      required this.contextMenuController,
      required this.contextMenuClear,
      required this.contextMenuIsShown,
      this.autoScrollController,
      this.contextMenuBuilder});
  final void Function(T)? onTap;
  final void Function(T)? onLongTap;
  final void Function(T)? onDoubleTap;
  final void Function(int previousPosition, int newPosition, T item, T? before,
      T? after, T? parent)? onReorder;
  final List<T>? selected;
  bool isSelected(T item) => selected?.contains(item) == true;
  final Widget Function<T>(BuildContext context, Offset offset, T item)?
      contextMenuBuilder;
  final void Function() contextMenuClear;
  final bool Function() contextMenuIsShown;
  final ContextMenuController? contextMenuController;
  final AutoScrollController? autoScrollController;

  //final Widget Function() contextMenuShow();
}

class ExtendedListView<T> extends StatefulWidget {
  const ExtendedListView({
    super.key,
    this.selected,
    required this.items,
    this.buildToolbarSub,
    this.buildToolbarLeading,
    this.buildToolbarFooter,
    this.buildToolbar,
    this.buildViewIcons,
    required this.listDataProviders,
    this.orderBy,
    this.filterBy,
    this.onOrderByChange,
    this.onFilterByChange,
    this.onSearchChange,
    this.onSearchClear,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onReorder,
    this.isLoading = false,
    this.enableSearch = true,
    this.defaultSearchText,
    this.footerText = "",
    this.contextMenuBuilder,
    this.autoScrollController,
    this.selectedFilterBy,
    this.selectedOrderBy,
    String? settingsKey,
    SettingsStorage? settings,
  }) : settingsStorer = settings
  // (settings == null && settingsKey != null)
  //           ? SharedPreferencesSettings(settingsKey)
  //           : settings
  ;

  @override
  State<ExtendedListView<T>> createState() => _ExtendedListViewState<T>();
  final String footerText;
  final List<T>? selected;
  final List<T> items;

  final bool enableSearch;

  final List<ListViewLayoutProvider<T>> listDataProviders;

  final List<ListViewOrderByItem>? orderBy;
  final List<ListViewFilterByItem>? filterBy;

  final bool isLoading;

  final Function(ListViewOrderByItem?)? onOrderByChange;
  final Function(ListViewFilterByItem?)? onFilterByChange;
  final Function(String?)? onSearchChange;
  final Function(String?)? onSearchClear;

  final Function(T)? onTap;
  final Function(T)? onLongTap;
  final Function(T)? onDoubleTap;
  final void Function(int previousPosition, int newPosition, T item, T? before,
      T? after, T? parent)? onReorder;

  final Widget Function(BuildContext)? buildToolbarSub;
  final Widget Function(BuildContext)? buildToolbarLeading;
  final Widget Function(BuildContext)? buildToolbarFooter;
  final Widget Function(BuildContext)? buildToolbar;

  final List<Widget> Function(BuildContext)? buildViewIcons;
  final Widget Function<T>(BuildContext context, Offset offset, T item)?
      contextMenuBuilder;
  final SettingsStorage? settingsStorer;
  final AutoScrollController? autoScrollController;
  final String? defaultSearchText;

  final dynamic selectedOrderBy;
  final List<dynamic>? selectedFilterBy;
}

class _ExtendedListViewState<T> extends State<ExtendedListView<T>> {
  late ListViewLayoutProvider<T> _listViewType;
  late TextEditingController _searchController;
  late double _gridColumns;
  final ContextMenuController _contextMenuController = ContextMenuController();

  //TODO auto scroll if required
  // Future _scrollToCounter() async {
  //   await controller.scrollToIndex(counter,
  //       preferPosition: AutoScrollPosition.begin);
  //   controller.highlight(counter);
  // }
  // setState(() => counter = state.selection.index);
  //         _scrollToCounter();
//  return AutoScrollTag(
//                 key: ValueKey(index),
//                 controller: controller,
//                 index: index,
//                 child: GridViewEntryItem(
//                   photo: entry.entry,
//                   tileStyle: ViewEntryListGridTileStyle.twoLine,
//                   onTap: widget.onTap,
//                   onDoubleTap: widget.onDoubleTap,
//                 ));

  @override
  void initState() {
    _listViewType = widget.listDataProviders[0];
    _gridColumns = 4;
    _searchController = TextEditingController();
    _searchController.text = (widget.defaultSearchText ?? "");

    if (widget.settingsStorer != null) {
      //_listViewType =
      // widget.settingsStorer!.getListViewType().then((value) {
      //   loggy.debug("Updating the list view type from settings $value");
      //   setState(() {
      //     _listViewType = value;
      //   });
      // });
      // widget.settingsStorer!.getGridColumns().then((value) {
      //   loggy.debug("Updating the grid columnsS from settings $value");
      //   setState(() {
      //     _gridColumns = value;
      //   });
      // });

      //_gridColumns =  widget.settingsStorer!.getGridColumns();
    } else {}

    super.initState();
  }

  Widget buildSubToolbar() {
    List<Widget> widgets = [];
    if (_listViewType.buildToolbarSub != null) {
      widgets.add(_listViewType.buildToolbarSub!(context));
    }
    if (widget.buildToolbarSub != null) {
      widgets.add(widget.buildToolbarSub!(context));
    }
    if (widgets.isNotEmpty) {
      return Row(
        children: widgets,
      );
    }
    return Container();
  }

  Widget buildToolbarLeading() {
    List<Widget> widgets = [];

    if (widget.buildToolbarLeading != null) {
      widgets.add(widget.buildToolbarLeading!(context));
    }
    if (widgets.isNotEmpty) {
      return Row(
        children: widgets,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildToolbarLeading(),
        _buildToolbar(context),
        buildSubToolbar(),
        Expanded(child: buildContent(context)),
        buildFooter(context),
      ],
    );
  }

  Widget buildFooter(BuildContext context) {
    List<Widget> w = [];
    if (_listViewType.getSizeParameters != null) {
      var params = _listViewType.getSizeParameters!();
      if (params.getLabel != null) {
        w.add(Text(params.getLabel!(_gridColumns)));
      }
      w.add(Slider(
          value: _gridColumns,
          min: params.min,
          max: params.max,
          onChanged: ((p0) async {
            if (widget.settingsStorer != null) {
              widget.settingsStorer!.setgridColumns(p0);
            }
            setState(() {
              _gridColumns = p0;
            });
          })));
    }

    if (widget.buildToolbarFooter != null) {
      w.add(widget.buildToolbarFooter!(context));
    }

    if (_listViewType.buildToolbarFooter != null) {
      w.add(_listViewType.buildToolbarFooter!(context));
    }

    if (w.isEmpty) {
      return Container();
    }

    return SizedBox(
        height: 35,
        child: Row(children: [Expanded(child: Text(widget.footerText)), ...w]));
  }

  Widget buildContent(BuildContext context) {
    if (widget.isLoading) {
      if (_listViewType.buildLoadingContent != null) {
        return _listViewType.buildLoadingContent!();
      }
      return const Center(
          child:
              Column(children: [CircularProgressIndicator(), Text("Loading")]));
    }

    if (widget.items.isEmpty) {
      if (_listViewType.buildNoContent != null) {
        return _listViewType.buildNoContent!();
      }
      return const Text("No matching entries");
    }

    return _listViewType.buildContent(
        context,
        widget.items,
        ExtendedListContext<T>(
            //TODO need to set parameters.
            selected: widget.selected,
            onTap: widget.onTap,
            onLongTap: widget.onLongTap,
            onDoubleTap: widget.onDoubleTap,
            onReorder: widget.onReorder,
            autoScrollController: widget.autoScrollController,
            contextMenuController: _contextMenuController,
            contextMenuBuilder: widget.contextMenuBuilder,
            contextMenuIsShown: () => _contextMenuController.isShown,
            contextMenuClear: () => _contextMenuController.remove()));
  }

  Widget? buildToolbarOrderBy() {
    if (widget.onOrderByChange != null && widget.orderBy != null) {
      if (widget.orderBy!.length > 1) {
        return MenuAnchor(
          // childFocusNode: _buttonFocusNode,
          menuChildren: widget.orderBy!
              .map((e) => MenuItemButton(
                    leadingIcon: widget.selectedOrderBy == e ||
                            widget.selectedOrderBy == e.value
                        ? const Icon(Icons.check)
                        : null,
                    child: Text(e.label),
                    onPressed: () => widget.onOrderByChange!(e),
                  ))
              .toList(),

          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              // focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.arrow_downward),
            );
          },
        );
      }
    }
    return null;
  }

  Widget? buildToolbarFilterBy() {
    if (widget.onFilterByChange != null && widget.filterBy != null) {
      if (widget.filterBy!.length > 1) {
        return MenuAnchor(
          // childFocusNode: _buttonFocusNode,
          menuChildren: widget.filterBy!
              .map((e) => MenuItemButton(
                    leadingIcon: (widget.selectedFilterBy != null &&
                            (widget.selectedFilterBy!.contains(e) ||
                                widget.selectedFilterBy!.contains(e.value)))
                        ? const Icon(Icons.check)
                        : null,
                    child: Text(e.label),
                    onPressed: () => widget.onFilterByChange!(e),
                  ))
              .toList(),

          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              // focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.arrow_downward),
            );
          },
        );
      }
    }
    return null;
  }

  void addToolbarSeparator(List<Widget> btns) {
    if (btns.isNotEmpty) {
      btns.add(const Text("|"));
      // btns.add(const VerticalDivider(
      //   color: Colors.red,
      //   thickness: 4,
      //   width: 4,
      // ));
    }
  }

  Widget _buildToolbar(BuildContext context) {
    List<Widget> btns = [];

    Widget? w = buildToolbarOrderBy();
    if (w != null) {
      btns.add(w);
    }

    w = buildToolbarFilterBy();
    if (w != null) {
      addToolbarSeparator(btns);
      btns.add(w);
    }

    if (widget.listDataProviders.length > 1) {
      addToolbarSeparator(btns);
    }

    return Row(
      children: [
        Expanded(
          child: buildSearchBox(context),
        ),
        (widget.buildToolbar != null)
            ? widget.buildToolbar!(context)
            : Container(),
        ...btns,
        ...widget.listDataProviders.length < 2
            ? []
            : widget.listDataProviders
                .map<Widget>(
                  (e) => buildSelectViewButton(context, e),
                )
                .toList(),
        ...widget.buildViewIcons != null ? widget.buildViewIcons!(context) : []
      ],
    );
  }

  Widget buildSearchBox(BuildContext context) {
    if (widget.enableSearch) {
      return Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _searchController,
            onChanged: (value) {
              if (widget.onSearchChange != null) {
                widget.onSearchChange!(value);
              }
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(
                    Icons.search), // prefixIcon ?? Icon(m.Icons.done),
                suffixIcon: widget.onSearchClear == null
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: _searchController.text == ""
                            ? null
                            : () =>
                                widget.onSearchClear!(_searchController.text),
                      )),
          ))
        ],
      );
    }
    return Container();
  }

  Widget buildSelectViewButton(
      BuildContext context, ListViewLayoutProvider<T> type) {
    if (!type.visible) {
      return Container();
    }

    if (!type.enabled) {
      return Icon(type.selectIcon);
    } else {
      if (_listViewType == type) {
        return Icon(type.selectIcon);
      } else {
        return IconButton(
            onPressed: () => _selectViewType(type),
            icon: Icon(type.selectIcon));
      }
    }
  }

  _selectViewType(ListViewLayoutProvider<T> viewType) async {
    if (widget.settingsStorer != null) {
      await widget.settingsStorer!.setGridListViewType(viewType);
    }
    setState(() {
      _listViewType = viewType;
    });
  }
}
