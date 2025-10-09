import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';

class MindleDropdown<T> extends StatefulWidget {
  final String hint;
  final T? value;
  final List<MindleDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const MindleDropdown({
    super.key,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  State<MindleDropdown<T>> createState() => _MindleDropdownState<T>();
}

class _MindleDropdownState<T> extends State<MindleDropdown<T>>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;
    final selectedItem = hasValue
        ? widget.items.firstWhere((item) => item.value == widget.value)
        : null;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: hasValue ? MindleColors.mainGreen : MindleColors.gray6,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hasValue ? selectedItem!.label : widget.hint,
                    style: MindleTextStyles.body1(
                      color: hasValue
                          ? MindleColors.mainGreen
                          : MindleColors.gray8,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: hasValue
                        ? MindleColors.mainGreen
                        : MindleColors.gray5,
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: widget.items.map((item) {
                      return InkWell(
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: MindleColors.gray4,
                            border: Border(
                              top: BorderSide(color: MindleColors.gray6),
                            ),
                          ),
                          child: Text(
                            item.label,
                            style: MindleTextStyles.body1(
                              color: MindleColors.gray1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class MindleDropdownItem<T> {
  final T value;
  final String label;

  const MindleDropdownItem({required this.value, required this.label});
}
