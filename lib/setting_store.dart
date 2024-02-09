import 'package:extended_list_view/extended_list_view.dart';

abstract class SettingsStorage {
  Future<double> getGridColumns([double defaultValue = 5]);
  Future<ListViewLayoutProvider> getListViewType(
      [ListViewLayoutProvider defaultValue]);
  Future<String> getSearchString();
  Future<void> setgridColumns(
    double gridColumns,
  );
  Future<void> setSearchString(String searchString);
  Future<void> setGridListViewType(ListViewLayoutProvider listViewType);
}
