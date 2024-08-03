//https://api.flutter.dev/flutter/widgets/ContextMenuController-class.html

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A builder that includes an Offset to draw the context menu at.
// typedef ContextMenuBuilder<T> = Widget Function<B>(
//     BuildContext context, Offset offset, List<B> item);

// _ContextMenuRegion(
//           contextMenuBuilder: (BuildContext context, Offset offset) {
//             // The custom context menu will look like the default context menu
//             // on the current platform with a single 'Print' button.
//             return AdaptiveTextSelectionToolbar.buttonItems(
//               anchors: TextSelectionToolbarAnchors(
//                 primaryAnchor: offset,
//               ),
//               buttonItems: <ContextMenuButtonItem>[
//                 ContextMenuButtonItem(
//                   onPressed: () {
//                     ContextMenuController.removeAny();
//                     _showDialog(context);
//                   },
//                   label: 'Print',
//                 ),
//               ],
//             );
//           },

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class ContextMenuRegion<T> extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
    required this.item,
    required this.contextMenuController,
  });
  final T item;

  final ContextMenuController contextMenuController;

  /// Builds the context menu.
  final Widget Function<T>(BuildContext context, Offset offset, T item)
      contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  Offset? _longPressOffset;

//  = ContextMenuController()
  @override
  void initState() {
    _contextMenuController =
        widget.contextMenuController; //?? ContextMenuController();
    super.initState();
  }

  late final ContextMenuController _contextMenuController;

  static bool get _longPressEnabled {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!_contextMenuController.isShown) {
      return;
    }
    _hide();
  }

  // void _onTapUp(TapUpDetails details) {
  //   print("Tap Up");
  //   if (!_contextMenuController.isShown) {
  //     return;
  //   }
  //   _hide();
  // }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position, widget.item);
      },
    );
    print("context_menu isShown = ${_contextMenuController.isShown}");
  }

  void _hide() {
    _contextMenuController.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      //onTapUp: _onTapUp,
      onLongPress: _longPressEnabled ? _onLongPress : null,
      onLongPressStart: _longPressEnabled ? _onLongPressStart : null,
      child: widget.child,
    );
  }
}
