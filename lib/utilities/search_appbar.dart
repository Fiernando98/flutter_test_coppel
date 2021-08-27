import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchAppBar extends AppBar {
  final String searchText;
  final ValueChanged<String> onTextChange;
  final bool canSearch;
  final TextStyle? hintTextStyle;
  final TextStyle? searchTextStyle;

  ///[searchText] is going to be the hint inside the text field
  ///
  ///[onTextChange] is the listener if the text was changed
  ///
  ///[canSearch] is the bool if the widget can search or not
  ///
  ///[hintTextStyle] is the style of [searchText]
  ///
  ///[searchTextStyle] is the style of the text field

  SearchAppBar(
      {Key? key,
      required this.searchText,
      required this.onTextChange,
      this.canSearch = true,
      this.hintTextStyle,
      this.searchTextStyle,
      final Widget? leading,
      final bool automaticallyImplyLeading = true,
      final Widget? title,
      final List<Widget>? actions,
      final Widget? flexibleSpace,
      final PreferredSizeWidget? bottom,
      final double? elevation,
      final Color? shadowColor,
      final ShapeBorder? shape,
      final Color? backgroundColor,
      final Color? foregroundColor,
      final IconThemeData? iconTheme,
      final IconThemeData? actionsIconTheme,
      final TextTheme? textTheme,
      final bool primary = true,
      final bool? centerTitle,
      final bool excludeHeaderSemantics = false,
      final double? titleSpacing,
      final double toolbarOpacity = 1.0,
      final double bottomOpacity = 1.0,
      final double? toolbarHeight,
      final double? leadingWidth,
      final bool? backwardsCompatibility,
      final TextStyle? toolbarTextStyle,
      final TextStyle? titleTextStyle,
      final SystemUiOverlayStyle? systemOverlayStyle})
      : super(
            key: key,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: title,
            actions: actions,
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: elevation,
            shadowColor: shadowColor,
            shape: shape,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            primary: primary,
            centerTitle: centerTitle,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
            toolbarHeight: toolbarHeight,
            leadingWidth: leadingWidth,
            toolbarTextStyle: toolbarTextStyle,
            titleTextStyle: titleTextStyle,
            systemOverlayStyle: systemOverlayStyle);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _txtSearchController = TextEditingController();
  bool _isSearching = false;

  List<Widget> _actionsButtons() {
    if (_isSearching) {
      return [
        IconButton(
            icon: Icon((_txtSearchController.text.isEmpty)
                ? Icons.close
                : Icons.cleaning_services),
            onPressed: () => (_txtSearchController.text.isEmpty)
                ? _stopSearching()
                : _clearSearchQuery())
      ];
    }
    List<Widget> _actions = [];
    if (widget.actions?.isNotEmpty == true) _actions = widget.actions!.toList();
    _actions.insert(
        0,
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: (widget.canSearch) ? _startSearch : null));
    return _actions;
  }

  Widget _searchBar() {
    return TextField(
        controller: _txtSearchController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: widget.searchText,
            border: InputBorder.none,
            hintStyle: widget.hintTextStyle ??
                Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    color: Theme.of(context)
                        .appBarTheme
                        .titleTextStyle
                        ?.color
                        ?.withOpacity(0.8))),
        style: widget.searchTextStyle ??
            Theme.of(context).appBarTheme.titleTextStyle,
        onChanged: updateSearchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        key: widget.key,
        leading: _isSearching
            ? BackButton(onPressed: _stopSearching)
            : widget.leading,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: _isSearching ? _searchBar() : widget.title,
        actions: _actionsButtons(),
        flexibleSpace: widget.flexibleSpace,
        bottom: widget.bottom,
        elevation: widget.elevation,
        shadowColor: widget.shadowColor,
        shape: widget.shape,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        iconTheme: widget.iconTheme,
        actionsIconTheme: widget.actionsIconTheme,
        primary: widget.primary,
        centerTitle: widget.centerTitle,
        excludeHeaderSemantics: widget.excludeHeaderSemantics,
        titleSpacing: widget.titleSpacing,
        toolbarOpacity: widget.toolbarOpacity,
        bottomOpacity: widget.bottomOpacity,
        toolbarHeight: widget.toolbarHeight,
        leadingWidth: widget.leadingWidth,
        toolbarTextStyle: widget.toolbarTextStyle,
        titleTextStyle: widget.titleTextStyle,
        systemOverlayStyle: widget.systemOverlayStyle);
  }

  ///start to build the text field
  void _startSearch() {
    _isSearching = true;
    setState(() {});
  }

  ///stop and destroy the text field
  void _stopSearching() {
    _clearSearchQuery();
    _isSearching = false;
    setState(() {});
  }

  ///update the text using value changer
  void updateSearchQuery(String newQuery) {
    widget.onTextChange(newQuery);
    setState(() {});
  }

  ///clear all the text in the text field
  void _clearSearchQuery() {
    _txtSearchController.clear();
    updateSearchQuery("");
    setState(() {});
  }
}
