part of '../personal_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final List<T> items;
  final bool excludeSelected;
  final String headerText;
  final ValueSetter<T> onItemSelect;
  final EdgeInsets padding;
  final TextStyle? itemTextStyle;
  final Widget Function(BuildContext context, T result) listItemBuilder;

  const _ItemsList({
    Key? key,
    required this.scrollController,
    required this.items,
    required this.excludeSelected,
    required this.headerText,
    required this.onItemSelect,
    required this.listItemBuilder,
    required this.padding,
    this.itemTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: padding,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final selected = !excludeSelected && headerText == items[index];
          return Material(
            color: transparent,
            child: InkWell(
              splashColor: transparent,
              highlightColor: grey[200],
              onTap: () => onItemSelect(items[index]),
              child: Container(
                color: selected ? Theme.of(context).colorScheme.primary : transparent,
                padding: _listItemPadding,
                child: AbsorbPointer(child: listItemBuilder(context, items[index])),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<List<T>> defaultFutureRequest<T>(String value) async {
  return <T>[];
}

class _SearchField<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<List<T>> onSearchedItems;
  final SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final ValueChanged<bool>? onFutureRequestLoading;
  final ValueChanged<bool>? mayFoundResult;
  final bool Function(T item, String searchPrompt)? searchFunction;

  const _SearchField.forListData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
    required this.searchFunction,
  })  : searchType = SearchType.onListData,
        futureRequest = defaultFutureRequest,
        futureRequestDelay = null,
        onFutureRequestLoading = null,
        mayFoundResult = null,
        super(key: key);

  const _SearchField.forRequestData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.onFutureRequestLoading,
    required this.mayFoundResult,
    required this.searchFunction,
  })  : searchType = SearchType.onRequestData,
        super(key: key);

  @override
  State<_SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<_SearchField<T>> {
  final searchCtrl = TextEditingController();
  bool isFieldEmpty = false;
  FocusNode focusNode = FocusNode();
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.searchType == SearchType.onRequestData && widget.items.isEmpty) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  searchFunctionDefault(T item, String searchPrompt) {
    /* return item.toLowerCase().contains(
            searchPrompt.toLowerCase(),
          ); */
    return true;
  }

  void onSearch(String str) {
    final result = widget.items.where((T item) => (widget.searchFunction ?? searchFunctionDefault)(item, str)).toList();
    widget.onSearchedItems(result);
  }

  void onClear() {
    if (searchCtrl.text.isNotEmpty) {
      searchCtrl.clear();
      widget.onSearchedItems(widget.items);
    }
  }

  void searchRequest(String val) async {
    List<T> result = <T>[];
    var wFutureReq = widget.futureRequest;
    if (wFutureReq != null) {
      try {
        result = await wFutureReq(val);
        widget.onFutureRequestLoading!(false);
      } catch (_) {
        widget.onFutureRequestLoading!(false);
      }
    }
    widget.onSearchedItems(isFieldEmpty ? widget.items : result);
    widget.mayFoundResult!(result.isNotEmpty);

    if (isFieldEmpty) {
      isFieldEmpty = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        focusNode: focusNode,
        onChanged: (String val) async {
          if (val.isEmpty) {
            isFieldEmpty = true;
          } else if (isFieldEmpty) {
            isFieldEmpty = false;
          }

          if (widget.searchType != null && widget.searchType == SearchType.onRequestData && val.isNotEmpty) {
            widget.onFutureRequestLoading!(true);

            if (widget.futureRequestDelay != null) {
              _delayTimer?.cancel();
              _delayTimer = Timer(widget.futureRequestDelay ?? Duration.zero, () {
                searchRequest(val);
              });
            } else {
              searchRequest(val);
            }
          } else if (widget.searchType == SearchType.onListData) {
            onSearch(val);
          } else {
            widget.onSearchedItems(widget.items);
          }
        },
        controller: searchCtrl,
        decoration: InputDecoration(
          //   filled: true,
          //   fillColor: ,
          constraints: const BoxConstraints.tightFor(height: 40),
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search, size: 22),
          suffixIcon: GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: grey.withOpacity(.25),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: grey.withOpacity(.25),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: grey.withOpacity(.25),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
