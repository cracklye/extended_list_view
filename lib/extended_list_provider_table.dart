import 'package:extended_list_view/extended_list_view.dart';

class ListViewLayoutTable<T> extends ListViewLayoutDefault<T> {
  ListViewLayoutTable(
      {super.enableSearch,
      super.enableSorting,
      super.key = "list_table",
      required super.selectIcon});
}
