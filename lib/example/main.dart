import 'package:extended_list_view/extended_list_provider_gallery.dart';
import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'test_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

var contextMenuBuilder =
    <TestItem>(BuildContext context, Offset offset, TestItem item) {
  // The custom context menu will look like the default context menu
  // on the current platform with a single 'Print' button.

  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: TextSelectionToolbarAnchors(
      primaryAnchor: offset,
    ),
    buttonItems: <ContextMenuButtonItem>[
      ContextMenuButtonItem(
        onPressed: () {
          ContextMenuController.removeAny();
          // _showDialog(context);
        },
        label: 'Print',
      ),
      ContextMenuButtonItem(
        onPressed: () {
          ContextMenuController.removeAny();
          // _showDialog(context);
        },
        label: 'Print ${item.toString()}',
      ),
    ],
  );
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool enableMoveToItem = false;
  bool _listIsEmpty = false;
  bool _isLoading = false;
  bool _enableSearch = false;
  bool _enableContextMenu = false;
  bool _enableBuildToolbarFooter = false;
  bool _enableBuildToolbarSub = false;
  bool _enableOrderBy = false;
  bool _enableFilterBy = false;
  bool _fixedSize = false;
  bool _enableBuildToolbarLeading = false;
  bool _multiLayoutProvider = false;

  static final AutoScrollController _autoscrollController =
      AutoScrollController();

  List<TestItem> _selected = [];
  bool _enableSelected = false;
  String _lastAction = "";
  void _toggleEnableBuildToolbarSub() {
    setState(() {
      _enableBuildToolbarSub = !_enableBuildToolbarSub;
    });
  }

  void _toggleEnableBuildToolbarLeading() {
    setState(() {
      _enableBuildToolbarLeading = !_enableBuildToolbarLeading;
    });
  }

  void _toggleMultiLayoutProvider() {
    setState(() {
      _multiLayoutProvider = !_multiLayoutProvider;
    });
  }

  void _toggleEnableOrderBy() {
    setState(() {
      _enableOrderBy = !_enableOrderBy;
    });
  }

  void _toggleEnableFilterBy() {
    setState(() {
      _enableFilterBy = !_enableFilterBy;
    });
  }

  void _toggleEnableBuildToolbarFooter() {
    setState(() {
      _enableBuildToolbarFooter = !_enableBuildToolbarFooter;
    });
  }

  void _toggleFixedSize() {
    setState(() {
      _fixedSize = !_fixedSize;
    });
  }

  void _toggleEnableSearch() {
    setState(() {
      _enableSearch = !_enableSearch;
    });
  }

  void _toggleEnableContextMenu() {
    setState(() {
      _enableContextMenu = !_enableContextMenu;
    });
  }

  void _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _toggleEnableMoveToItem() {
    setState(() {
      enableMoveToItem = !enableMoveToItem;
    });
  }

  void _toggleEnableSelected() {
    setState(() {
      _enableSelected = !_enableSelected;
    });
  }

  void _toggleListIsEmpty() {
    setState(() {
      _listIsEmpty = !_listIsEmpty;
    });
  }

  void setLastAction(String msg, [TestItem? testItem]) {
    setState(() {
      _lastAction = msg;
    });
    if (testItem != null) {
      if (_selected.contains(testItem)) {
        _selected.remove(testItem);
      } else {
        _selected.add(testItem);
      }

      setState(() {
        _selected = _selected;
      });
    }
  }

  List<TestItem> options = [];

  @override
  void initState() {
    super.initState();
    List<TestItem> opt = [];
    for (int i = 0; i < 200; i++) {
      opt.add(TestItem(label: "Test Item $i", index: i));
    }
    options = opt;
  }
  // @override
  // void setState(VoidCallback fn) {
  //   super.setState(fn);
  //   List<TestItem> opt = [];
  //   for (int i = 0; i < 200; i++) {
  //     opt.add(TestItem(label: "Test Item $i"));
  //   }
  //   options = opt;
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Wrap(
            children: [
              const Text(" | Fixed Size: "),
              Checkbox(
                  value: _fixedSize, onChanged: (value) => _toggleFixedSize()),
              const Text(" | Empty List: "),
              Checkbox(
                  value: _listIsEmpty,
                  onChanged: (value) => _toggleListIsEmpty()),
              const Text(" | Enable Move To Item: "),
              Checkbox(
                  value: enableMoveToItem,
                  onChanged: (value) => _toggleEnableMoveToItem()),
              const Text(" | Enable Search "),
              Checkbox(
                  value: _enableSearch,
                  onChanged: (value) => _toggleEnableSearch()),
              const Text(" | Enable Context Menu "),
              Checkbox(
                  value: _enableContextMenu,
                  onChanged: (value) => _toggleEnableContextMenu()),
              const Text(" | Enable Selected "),
              Checkbox(
                  value: _enableSelected,
                  onChanged: (value) => _toggleEnableSelected()),
              const Text(" | Is Loading "),
              Checkbox(
                  value: _isLoading, onChanged: (value) => _toggleIsLoading()),
              const Text(" | Build TB Sub "),
              Checkbox(
                  value: _enableBuildToolbarSub,
                  onChanged: (value) => _toggleEnableBuildToolbarSub()),
              const Text(" |  Build TB Footer "),
              Checkbox(
                  value: _enableBuildToolbarFooter,
                  onChanged: (value) => _toggleEnableBuildToolbarFooter()),
              const Text(" | Leading toolbar"),
              Checkbox(
                  value: _enableBuildToolbarLeading,
                  onChanged: (value) => _toggleEnableBuildToolbarLeading()),
              const Text(" | Order By"),
              Checkbox(
                  value: _enableOrderBy,
                  onChanged: (value) => _toggleEnableOrderBy()),
              const Text(" | Filter By"),
              Checkbox(
                  value: _enableFilterBy,
                  onChanged: (value) => _toggleEnableFilterBy()),
              const Text(" | Multiple Layout Providers"),
              Checkbox(
                  value: _multiLayoutProvider,
                  onChanged: (value) => _toggleMultiLayoutProvider()),
              const Text(" | "),
            ],
          ),
          if (_enableSelected)
            Wrap(
              children: _selected
                  .map((i) => enableMoveToItem
                      ? TextButton(
                          onPressed: () async {
                            print("Clicked $i");
                            await _autoscrollController.scrollToIndex(i.index,
                                preferPosition: AutoScrollPosition.begin);
                            _autoscrollController.highlight(i.index);
                          },
                          child: Text(i.toString()))
                      : Text(i.toString()))
                  .toList(),
            ),
          const Divider(),
          _fixedSize
              ? SizedBox(height: 200, child: _buildListView(context))
              : Expanded(child: _buildListView(context)),
          Text(_lastAction),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildListView(BuildContext context) {
    return ExtendedListView<TestItem>(
      autoScrollController: enableMoveToItem ? _autoscrollController : null,
      isLoading: _isLoading,
      defaultSearchText: "Default Search Text",
      enableSearch: _enableSearch,
      selected: _enableSelected ? _selected : [],
      onTap: (p0) => setLastAction('onTap: $p0', p0),
      onDoubleTap: (p0) => setLastAction('onDoubleTap: $p0', p0),
      onLongTap: (p0) => setLastAction('onLongTap: $p0', p0),
      onFilterByChange: (p0) => setLastAction('onFilterByChange: $p0'),

      selectedOrderBy: 2,
      orderBy: _enableOrderBy
          ? [
              ListViewOrderByItem(label: "Name", value: 1),
              ListViewOrderByItem(label: "Sort order", value: 2),
            ]
          : [],
      selectedFilterBy: const [2, 3],
      filterBy: _enableFilterBy
          ? [
              ListViewFilterByItem(label: "Name", value: 1),
              ListViewFilterByItem(label: "sort Order", value: 2),
              ListViewFilterByItem(label: "Somthing else", value: 3),
            ]
          : [],
      onOrderByChange: (p0) => setLastAction('onOrderByChange: $p0'),
      onReorder: (int previousPosition, int newPosition, TestItem item,
              TestItem? before, TestItem? after, TestItem? parent) =>
          setLastAction(
              'onReorder: Previous = $previousPosition,new= $newPosition,item= $item, before= $before, after= $after, parent=$parent'),
      onSearchChange: (p0) => setLastAction('onSearchChange: $p0'),
      onSearchClear: (p0) => setLastAction('onSearchClear: $p0'),
      listDataProviders: [
        ListViewLayoutList(selectIcon: Icons.list),
        if (_multiLayoutProvider)
          ListViewLayoutGrid<TestItem>(selectIcon: Icons.grid_3x3),
        if (_multiLayoutProvider)
          ListViewLayoutSortable<TestItem>(selectIcon: Icons.sort),
        if (_multiLayoutProvider)
          ListViewLayoutTable(selectIcon: Icons.table_bar_rounded),
        if (_multiLayoutProvider) ListViewLayoutGallery(selectIcon: Icons.image)
      ],
      contextMenuBuilder: _enableContextMenu ? contextMenuBuilder : null,
      buildToolbarFooter: _enableBuildToolbarFooter
          ? (context) => const Text("This is the toolbar footer")
          : null,
      buildToolbarSub: _enableBuildToolbarSub
          ? (context) => const Text("This is the toolbar sub")
          : null,

      buildToolbarLeading: _enableBuildToolbarLeading
          ? (context) => const Text("This is the toolbar Leading")
          : null,

      // buildToolbarFooter: _enableBuildToolbar? (context)=>  Text("This is the footer"):null,

      items: _listIsEmpty ? [] : options,
    );
  }
}
