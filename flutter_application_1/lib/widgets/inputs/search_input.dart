import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/debouncer.dart';

/// A search input field with built-in debounce support.
class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
  });
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? hintText;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = Debouncer();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) => _debouncer.run(() => widget.onChanged?.call(value)),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText ?? AppStrings.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                },
              )
            : null,
      ),
    );
  }
}
