import 'dart:async';

import 'package:flutter/material.dart';

export 'personal_dropdown.dart';

part 'cool_dropdown/animated_section.dart';

part 'cool_dropdown/dropdown_field.dart';

part 'cool_dropdown/overlay.dart';

part 'cool_dropdown/items_field.dart';

part 'cool_dropdown/builder.dart';

enum SearchType { onListData, onRequestData }

// typedef ListItemBuilder<T> = Widget Function(BuildContext context, T result);

class CustomDropdown<T> extends StatefulWidget {
  // required
  final Widget Function(BuildContext context, T result) listItemBuilder;
  final List<T> items;
  final TextEditingController controller;
  // // // additional
  final bool? canCloseOutsideBounds;
  final bool? hideSelectedFieldWhenOpen;
  final bool? excludeSelected;
  // Search
  final Future<List<T>> Function(String)? futureRequest;
  //duration after which the 'future Request' is to be executed
  final Duration? futureRequestDelay;
  final bool Function(T item, String searchPrompt)? searchFunction;
  final String Function(T item)? searchableTextItem;
  final void Function(T item) onItemSelect;
  final SearchType? searchType;
  final void Function(String value)? onChanged;

  // common
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Color? fillColor;

  CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    required this.listItemBuilder,
    this.onChanged,
    required this.onItemSelect,
    this.searchableTextItem,
    this.futureRequest,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items.map((e) => (searchableTextItem ?? (T item) => '$item')(e)).contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        searchType = null,
        futureRequestDelay = null,
        canCloseOutsideBounds = true,
        searchFunction = null,
        hideSelectedFieldWhenOpen = false,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    required this.listItemBuilder,
    required this.controller,
    required this.searchFunction,
    required this.searchableTextItem,
    required this.onItemSelect,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.fillColor = Colors.white,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items.map((e) => (searchableTextItem ?? (T item) => '$item')(e)).contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        futureRequest = null,
        searchType = SearchType.onListData,
        futureRequestDelay = null,
        super(key: key);

  const CustomDropdown.searchRequest({
    Key? key,
    required this.items,
    required this.listItemBuilder,
    required this.controller,
    this.onChanged,
    required Future<List<T>> Function(String) futureReq,
    required String Function(T)? searchableItemText,
    required bool Function(T, String) searchMethod,
    required this.onItemSelect,
    this.futureRequestDelay,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.fillColor = Colors.white,
  })  : /* assert(
          (listItemBuilder == null && listItemStyle == null) || (listItemBuilder == null && listItemStyle != null) || (listItemBuilder != null && listItemStyle == null),
          'Cannot use both listItemBuilder and listItemStyle.',
        ), */
        futureRequest = futureReq,
        searchFunction = searchMethod,
        searchableTextItem = searchableItemText,
        searchType = SearchType.onRequestData,
        super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';

    // hint style :: if provided then merge with default
    final hintStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay<T>(
          items: widget.items,
          controller: widget.controller,
          size: size,
          searchableTextItem: widget.searchableTextItem,
          listItemBuilder: widget.listItemBuilder,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle: widget.controller.text.isNotEmpty ? selectedStyle : hintStyle,
          hintText: hintText,
          onItemSelect: widget.onItemSelect,
          key: widget.key,
          searchFunction: widget.searchFunction,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
          futureRequest: widget.futureRequest,
          futureRequestDelay: widget.futureRequestDelay,
          hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenOpen,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField<T>(
            controller: widget.controller,
            onTap: showCallback,
            style: selectedStyle,
            borderRadius: widget.borderRadius,
            borderSide: widget.borderSide,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            suffixIcon: widget.fieldSuffixIcon,
            onChanged: widget.onChanged,
            fillColor: widget.fillColor,
          ),
        );
      },
    );
  }
}
