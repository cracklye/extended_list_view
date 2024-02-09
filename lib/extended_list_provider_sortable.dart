
import 'package:extended_list_view/extended_list_view.dart';

class ListViewLayoutSortable<T> extends ListViewLayoutDefault<T> {
  ListViewLayoutSortable(
      {super.enableSearch,
      super.enableSorting,
      super.key = "list_sortable",
      required super.selectIcon});
}
