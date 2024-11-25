part of '../personal_dropdown.dart';

const _headerPadding = EdgeInsets.only(
  left: 16.0,
  top: 16,
  bottom: 16,
  right: 14,
);
const _overlayOuterPadding = EdgeInsets.only(bottom: 12, left: 12, right: 12);
const _overlayShadowOffset = Offset(0, 6);
const _listItemPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

class _DropdownOverlay<T> extends StatefulWidget {
  final List<T> items;
  final TextEditingController controller;
  final Size size;
  final LayerLink layerLink;
  final void Function(T item) onItemSelect;
  final VoidCallback hideOverlay;
  final String hintText;
  final TextStyle? headerStyle;
  final bool excludeSelected;
  final bool? hideSelectedFieldWhenOpen;
  final bool canCloseOutsideBounds;
  final SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final bool Function(T item, String searchPrompt)? searchFunction;
  final String Function(T item)? searchableTextItem;
  final Widget Function(BuildContext context, T result) listItemBuilder;

  final Color? itemBgColor;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.controller,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    required this.listItemBuilder,
    required this.futureRequest,
    required this.searchFunction,
    required this.searchableTextItem,
    required this.onItemSelect,
    this.headerStyle,
    this.itemBgColor,
    this.excludeSelected = false,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.searchType,
    this.futureRequestDelay,
  }) : super(key: key);

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;

  late String headerText;
  late List<T> items;
  late List<T> filteredItems;
  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render1 = key1.currentContext?.findRenderObject() as RenderBox;
      final render2 = key2.currentContext?.findRenderObject() as RenderBox;
      final screenHeight = MediaQuery.of(context).size.height;
      double y = render1.localToGlobal(Offset.zero).dy;
      if (screenHeight - y < render2.size.height) {
        displayOverlayBottom = false;
        setState(() {});
      }
    });

    headerText = widget.controller.text;
    if (widget.excludeSelected && widget.items.length > 1 && widget.controller.text.isNotEmpty) {
      items = widget.items.where((item) => item != headerText).toList();
    } else {
      items = widget.items;
    }
    filteredItems = items;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // search availability check
    final onSearch = widget.searchType != null;

    // border radius
    final borderRadius = BorderRadius.circular(12);

    // overlay icon
    final overlayIcon = Icon(
      displayOverlayBottom ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
      size: 20,
    );

    // overlay offset
    final overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 60);

    // list padding
    final listPadding = onSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    // items list
    final child = stacked(
      overlayOffset,
      borderRadius,
      onSearch,
      context,
      overlayIcon,
      listItems(listPadding),
    );

    return GestureDetector(
      onTap: () => setState(() => displayOverly = false),
      child: widget.canCloseOutsideBounds
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: transparent,
              child: child,
            )
          : child,
    );
  }

  Widget listItems(EdgeInsets listPadding) {
    if (items.isNotEmpty) {
      return _ItemsList<T>(
        scrollController: scrollController,
        listItemBuilder: widget.listItemBuilder,
        excludeSelected: widget.items.length > 1 ? widget.excludeSelected : false,
        items: items,
        padding: listPadding,
        headerText: headerText,
        onItemSelect: (T value) {
          searchableTextItem(T item) => '$item';
          if (headerText != value) {
            widget.controller.text = (widget.searchableTextItem ?? searchableTextItem)(value);
          }
          widget.onItemSelect(value);
          setState(() => displayOverly = false);
        },
      );
    } else {
      if ((mayFoundSearchRequestResult != null && !mayFoundSearchRequestResult!) || widget.searchType == SearchType.onListData) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'No result found.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        return const SizedBox(height: 12);
      }
    }
  }

  Stack stacked(
    Offset overlayOffset,
    BorderRadius borderRadius,
    bool onSearch,
    BuildContext context,
    Icon overlayIcon,
    Widget list,
  ) {
    return Stack(
      children: [
        Positioned(
          width: widget.size.width + 24,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            followerAnchor: displayOverlayBottom ? Alignment.topLeft : Alignment.bottomLeft,
            showWhenUnlinked: false,
            offset: overlayOffset,
            child: Container(
              key: key1,
              padding: _overlayOuterPadding,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.itemBgColor ?? Theme.of(context).colorScheme.surface,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24.0,
                      color: (Theme.of(context).iconTheme.color ?? grey).withOpacity(.08),
                      offset: _overlayShadowOffset,
                    ),
                  ],
                ),
                child: Material(
                  color: transparent,
                  child: AnimatedSection(
                    animationDismissed: widget.hideOverlay,
                    expand: displayOverly,
                    axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                    child: SizedBox(
                      key: key2,
                      height: items.length > 4
                          ? onSearch
                              ? 330
                              : 285
                          : null,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (notification) {
                            notification.disallowIndicator();
                            return true;
                          },
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              scrollbarTheme: ScrollbarThemeData(
                                thumbVisibility: WidgetStateProperty.all(
                                  true,
                                ),
                                thickness: WidgetStateProperty.all(5),
                                radius: const Radius.circular(4),
                                thumbColor: WidgetStateProperty.all(grey),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!widget.hideSelectedFieldWhenOpen!)
                                  Padding(
                                    padding: _headerPadding,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            headerText.isNotEmpty ? headerText : widget.hintText,
                                            style: widget.headerStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        overlayIcon,
                                      ],
                                    ),
                                  ),
                                if (onSearch && widget.searchType == SearchType.onListData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField<T>.forListData(
                                      items: filteredItems,
                                      searchFunction: widget.searchFunction,
                                      onSearchedItems: (val) {
                                        setState(() => items = val);
                                      },
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _SearchField<T>.forListData(
                                              items: filteredItems,
                                              searchFunction: widget.searchFunction,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                            ),
                                          ),
                                          overlayIcon,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    )
                                else if (onSearch && widget.searchType == SearchType.onRequestData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField<T>.forRequestData(
                                      items: filteredItems,
                                      onFutureRequestLoading: (val) {
                                        setState(() {
                                          isSearchRequestLoading = val;
                                        });
                                      },
                                      futureRequest: widget.futureRequest,
                                      searchFunction: widget.searchFunction,
                                      futureRequestDelay: widget.futureRequestDelay,
                                      onSearchedItems: (val) {
                                        setState(() => items = val);
                                      },
                                      mayFoundResult: (val) => mayFoundSearchRequestResult = val,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _SearchField<T>.forRequestData(
                                              items: filteredItems,
                                              onFutureRequestLoading: (val) {
                                                setState(() {
                                                  isSearchRequestLoading = val;
                                                });
                                              },
                                              futureRequest: widget.futureRequest,
                                              searchFunction: widget.searchFunction,
                                              futureRequestDelay: widget.futureRequestDelay,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              mayFoundResult: (val) => mayFoundSearchRequestResult = val,
                                            ),
                                          ),
                                          overlayIcon,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                if (isSearchRequestLoading)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.0),
                                    child: Center(
                                        child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    )),
                                  )
                                else
                                  items.length > 4 ? Expanded(child: list) : list
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
