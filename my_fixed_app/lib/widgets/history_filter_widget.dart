import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import your app theme
import '../themes/app_theme.dart';

// ========== DESIGN SYSTEM CONSTANTS ==========
const double kControlHeight = 38;
const double kButtonHeight = 32;
const double kRadiusFull = 100;
const EdgeInsets kBlockPadding = EdgeInsets.all(14);
const EdgeInsets kChipPadding =
    EdgeInsets.symmetric(horizontal: 10, vertical: 6);
const EdgeInsets kButtonPadding =
    EdgeInsets.symmetric(horizontal: 12, vertical: 4);
// =============================================

class HistoryFilterWidget extends StatefulWidget {
  final Function(int year, String month, String letter) onFilterChanged;
  final int initialYear;
  final String initialMonth;
  final String initialLetter;
  final int resultCount;

  const HistoryFilterWidget({
    super.key,
    required this.onFilterChanged,
    required this.initialYear,
    required this.initialMonth,
    required this.initialLetter,
    this.resultCount = 0,
  });

  @override
  _HistoryFilterWidgetState createState() => _HistoryFilterWidgetState();
}

class _HistoryFilterWidgetState extends State<HistoryFilterWidget> {
  late int _selectedYear;
  late String _selectedMonth;
  late String _selectedLetter;
  bool _isExpanded = false; // Collapsed by default

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final List<String> _letters = [
    'All',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _selectedMonth = widget.initialMonth;
    _selectedLetter = widget.initialLetter;

    // Listen to theme changes
    AppTheme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  void _changeYear(int direction) {
    setState(() {
      _selectedYear += direction;
    });
    widget.onFilterChanged(_selectedYear, _selectedMonth, _selectedLetter);
  }

  void _selectMonth(String month) {
    setState(() {
      _selectedMonth = month;
    });
    widget.onFilterChanged(_selectedYear, _selectedMonth, _selectedLetter);
  }

  void _selectLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
    });
    widget.onFilterChanged(_selectedYear, _selectedMonth, _selectedLetter);
  }

  void _clearFilters() {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMM').format(now);

    setState(() {
      _selectedYear = now.year;
      _selectedMonth = currentMonth;
      _selectedLetter = 'All';
    });
    widget.onFilterChanged(_selectedYear, _selectedMonth, _selectedLetter);
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.glassContainer(
        borderRadius: _isExpanded ? 16 : kRadiusFull,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Collapsible Header - Always Visible (Clean version)
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(_isExpanded ? 16 : kRadiusFull),
            child: Container(
              padding: kBlockPadding,
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filter History',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Compact filter summary when collapsed
                  if (!_isExpanded)
                    Expanded(
                      child: Text(
                        '($_selectedMonth $_selectedYear${_selectedLetter != 'All' ? ' • $_selectedLetter' : ''})',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppTheme.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const Spacer(),
                  // Expand/Collapse Icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content with Animation
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.dividerColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Result Count and Clear Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Result Count Badge
                      Container(
                        height: kButtonHeight,
                        padding: kButtonPadding,
                        decoration: BoxDecoration(
                          color: widget.resultCount > 0
                              ? AppTheme.primaryColor.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(kRadiusFull),
                          border: Border.all(
                            color: widget.resultCount > 0
                                ? AppTheme.primaryColor.withOpacity(0.4)
                                : Colors.grey.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.resultCount} results',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Clear Button
                      GestureDetector(
                        onTap: _clearFilters,
                        child: Container(
                          height: kButtonHeight,
                          padding: kButtonPadding,
                          decoration: BoxDecoration(
                            color: AppTheme.glassColor,
                            borderRadius: BorderRadius.circular(kRadiusFull),
                            border: Border.all(color: AppTheme.glassBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 14,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Clear Filters',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Year and Month Row
                  Row(
                    children: [
                      // Year Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Year',
                              style: AppTextStyles.labelTertiary.copyWith(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: kControlHeight,
                              decoration: BoxDecoration(
                                color: AppTheme.glassColor,
                                borderRadius:
                                    BorderRadius.circular(kRadiusFull),
                                border: Border.all(color: AppTheme.glassBorder),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _changeYear(-1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(
                                        Icons.chevron_left,
                                        size: 18,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _selectedYear.toString(),
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _changeYear(1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 18,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Month Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Month',
                              style: AppTextStyles.labelTertiary.copyWith(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: kControlHeight,
                              decoration: BoxDecoration(
                                color: AppTheme.glassColor,
                                borderRadius:
                                    BorderRadius.circular(kRadiusFull),
                                border: Border.all(color: AppTheme.glassBorder),
                              ),
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedMonth,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                    dropdownColor: AppTheme.isDarkMode
                                        ? const Color(0xFF1A1A1A)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        _selectMonth(newValue);
                                      }
                                    },
                                    items: ['All', ..._months]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Text(
                                            value,
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                              color: AppTheme.textPrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Alphabet Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name Starts With',
                        style: AppTextStyles.labelTertiary.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: kControlHeight,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _letters.length,
                          itemBuilder: (context, index) {
                            final letter = _letters[index];
                            final isSelected = _selectedLetter == letter;

                            return GestureDetector(
                              onTap: () => _selectLetter(letter),
                              child: Container(
                                width: kControlHeight,
                                height: kControlHeight,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryColor.withOpacity(0.3)
                                      : AppTheme.glassColor,
                                  borderRadius:
                                      BorderRadius.circular(kRadiusFull),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.glassBorder,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    letter,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Active Filter Display
                  Container(
                    padding: kChipPadding,
                    decoration: BoxDecoration(
                      color: AppTheme.glassColor,
                      borderRadius: BorderRadius.circular(kRadiusFull),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 14,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Showing: $_selectedMonth $_selectedYear${_selectedLetter != 'All' ? ' • $_selectedLetter' : ''}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
