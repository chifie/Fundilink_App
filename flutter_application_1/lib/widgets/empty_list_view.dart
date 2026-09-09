import 'package:flutter/material.dart';

import 'empty_state.dart';
import 'entrance_animation.dart';

/// A ListView wrapper that automatically shows an empty state when the list is empty.
/// 
/// Wraps a ListView with conditional empty state display based on the items list.
/// Provides adaptive empty states for different scenarios (no data, loading, error, etc.).
class EmptyListView<T> extends StatelessWidget {
  const EmptyListView({
    super.key,
    required this.items,
    required this.buildItem,
    this.emptyStateBuilder,
    this.emptyStateIcon = Icons.inbox_outlined,
    this.emptyStateTitle = 'No items yet',
    this.emptyStateMessage,
    this.emptyStateActionLabel,
    this.emptyStateOnAction,
    this.appBarTitle,
    this.listViewKey,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.cacheExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.mainAxisScrollDirection = Axis.vertical,
    this.animateItems = false,
  });

  /// The list of items to display.
  final List<T> items;

  /// Builder function for creating list items.
  final Widget Function(T item, int index) buildItem;

  /// Custom builder for the empty state. Takes precedence over emptyStateIcon, etc.
  final Widget? Function(List<T> items)? emptyStateBuilder;

  /// Icon to display in the default empty state.
  final IconData emptyStateIcon;

  /// Title text for the default empty state.
  final String emptyStateTitle;

  /// Message text for the default empty state.
  final String? emptyStateMessage;

  /// Action label for the empty state button.
  final String? emptyStateActionLabel;

  /// Callback when the empty state action is tapped.
  final VoidCallback? emptyStateOnAction;

  /// Optional AppBar title for the list view.
  final String? appBarTitle;

  /// Key for the ListView.
  final Key? listViewKey;

  /// Whether the scrollable should be wrapped in a ShrinkWrapping scroll view.
  final bool shrinkWrap;

  /// Physics for the scrollable.
  final ScrollPhysics? physics;

  /// Padding around the list.
  final EdgeInsets? padding;

  /// Builder for separators between items.
  final Widget? Function(T item, int index)? separatorBuilder;

  /// Builder for a header widget above the list.
  final Widget? Function()? headerBuilder;

  /// Builder for a footer widget below the list.
  final Widget? Function()? footerBuilder;

  /// Extent to be used for cache calculations.
  final double? cacheExtent;

  /// Whether to add automatic keep alives to children.
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries to children.
  final bool addRepaintBoundaries;

  /// The axis along which the scroll view scrolls.
  final Axis mainAxisScrollDirection;

  /// Whether list items animate in with a staggered entrance. Defaults to
  /// false to keep long lists performant.
  final bool animateItems;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildListView(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    Widget emptyState;

    if (emptyStateBuilder != null) {
      emptyState = emptyStateBuilder!(items) ?? _defaultEmptyState(context);
    } else {
      emptyState = _defaultEmptyState(context);
    }

    return emptyState;
  }

  Widget _defaultEmptyState(BuildContext context) {
    return EmptyState(
      icon: emptyStateIcon,
      title: emptyStateTitle,
      message: emptyStateMessage,
      actionLabel: emptyStateActionLabel,
      onAction: emptyStateOnAction,
      addSemanticLabel: 'No items available: $emptyStateTitle',
    );
  }

  Widget _buildListView(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.zero;
    final effectivePhysics = physics ?? const BouncingScrollPhysics();
    final effectiveCacheExtent = cacheExtent;

    Widget itemBuilder(BuildContext context, int index) {
      final item = buildItem(items[index], index);
      if (!animateItems) return item;
      return EntranceAnimation(
        delay: Duration(milliseconds: (index * 40).clamp(0, 360)),
        child: item,
      );
    }

    Widget listContent;
    if (separatorBuilder != null) {
      listContent = ListView.separated(
        key: listViewKey,
        shrinkWrap: shrinkWrap,
        physics: effectivePhysics,
        padding: effectivePadding,
        cacheExtent: effectiveCacheExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        scrollDirection: mainAxisScrollDirection,
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            separatorBuilder!(items[index], index) ?? const SizedBox.shrink(),
        itemBuilder: itemBuilder,
      );
    } else {
      listContent = ListView.builder(
        key: listViewKey,
        shrinkWrap: shrinkWrap,
        physics: effectivePhysics,
        padding: effectivePadding,
        cacheExtent: effectiveCacheExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        scrollDirection: mainAxisScrollDirection,
        itemCount: items.length,
        itemBuilder: itemBuilder,
      );
    }

    if (mainAxisScrollDirection == Axis.horizontal) {
      listContent = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: listContent,
      );
    }

    if (headerBuilder != null) {
      listContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerBuilder!() ?? const SizedBox.shrink(),
          Expanded(child: listContent),
        ],
      );
    }

    if (footerBuilder != null) {
      listContent = Column(
        children: [
          listContent,
          footerBuilder!() ?? const SizedBox.shrink(),
        ],
      );
    }

    return listContent;
  }
}

/// A horizontal variant of EmptyListView for row-based layouts.
class EmptyListViewHorizontal<T> extends StatelessWidget {
  const EmptyListViewHorizontal({
    super.key,
    required this.items,
    required this.buildItem,
    this.emptyStateBuilder,
    this.emptyStateWidget,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.direction = Axis.horizontal,
  });

  /// The list of items to display.
  final List<T> items;

  /// Builder function for creating list items.
  final Widget Function(T item, int index) buildItem;

  /// Custom builder for the empty state.
  final Widget? Function(List<T> items)? emptyStateBuilder;

  /// Widget to display when list is empty.
  final Widget? emptyStateWidget;

  /// Spacing between items.
  final double spacing;

  /// Padding around the list.
  final EdgeInsets padding;

  /// Main axis alignment for the list.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for the list.
  final CrossAxisAlignment crossAxisAlignment;

  /// Layout direction.
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return emptyStateBuilder != null
          ? emptyStateBuilder!(items) ?? const SizedBox.shrink()
          : (emptyStateWidget ?? const SizedBox.shrink());
    }

    Widget listContent;
    if (direction == Axis.horizontal) {
      listContent = Wrap(
        spacing: spacing,
        children: List.generate(
          items.length,
          (index) => buildItem(items[index], index),
        ),
      );
    } else {
      listContent = Column(
        spacing: spacing,
        mainAxisAlignment: mainAxisAlignment,
        children: List.generate(
          items.length,
          (index) => buildItem(items[index], index),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: listContent,
    );
  }
}
