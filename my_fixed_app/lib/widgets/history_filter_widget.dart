import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ========== DESIGN SYSTEM CONSTANTS ==========
const double kControlHeight = 38; // Reduced from 42
const double kButtonHeight = 32; // For smaller buttons
const double kRadiusLarge = 16; // Reduced from 20
const double kRadiusMedium = 10; // Reduced from 12
const double kRadiusSmall = 8; // Reduced from 10
const double kRadiusFull = 100; // Max rounding for pill-shaped buttons
const EdgeInsets kBlockPadding = EdgeInsets.all(14); // Reduced from 16
const EdgeInsets kChipPadding =
    EdgeInsets.symmetric(horizontal: 10, vertical: 6); // Reduced
const EdgeInsets kButtonPadding =
    EdgeInsets.symmetric(horizontal: 12, vertical: 4); // For smaller buttons
const Color kPrimaryRed = Color(0xFFDC2626);
const Color kGlassWhite = Color.fromRGBO(255, 255, 255, 0.1);
const Color kGlassBorder = Color.fromRGBO(255, 255, 255, 0.2);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Reduced
      decoration: BoxDecoration(
        color: kGlassWhite,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: kGlassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16, // Reduced
          ),
        ],
      ),
      child: Padding(
        padding: kBlockPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with filter label and result count - COMPACT
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.white.withOpacity(0.7),
                  size: 16, // Reduced
                ),
                const SizedBox(width: 8), // Reduced
                Text(
                  'Filter History',
                  style: TextStyle(
                    fontSize: 14, // Reduced
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.1, // Reduced
                  ),
                ),
                const Spacer(),
                // Result Count Badge with max rounding - SMALLER
                Container(
                  height: kButtonHeight, // Smaller height
                  padding: kButtonPadding,
                  decoration: BoxDecoration(
                    color: widget.resultCount > 0
                        ? kPrimaryRed.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(kRadiusFull),
                    border: Border.all(
                      color: widget.resultCount > 0
                          ? kPrimaryRed.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.resultCount} results',
                      style: TextStyle(
                        fontSize: 11, // Reduced
                        fontWeight: FontWeight.w600,
                        color:
                            widget.resultCount > 0 ? kPrimaryRed : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6), // Reduced
                // Clear Button with max rounding - SMALLER
                GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    height: kButtonHeight, // Smaller height
                    padding: kButtonPadding,
                    decoration: BoxDecoration(
                      color: kGlassWhite,
                      borderRadius: BorderRadius.circular(kRadiusFull),
                      border: Border.all(color: kGlassBorder),
                    ),
                    child: Center(
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11, // Reduced
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1, // Reduced
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12), // Reduced from 14

            // Year and Month Row - COMPACT
            Row(
              children: [
                // Year Selector with max rounding
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year',
                        style: TextStyle(
                          fontSize: 11, // Reduced
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3, // Reduced
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced from 6
                      Container(
                        height: kControlHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(
                              kRadiusFull), // MAX ROUNDING
                          border: Border.all(color: kGlassBorder),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _changeYear(-1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8), // Reduced
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 18, // Reduced
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _selectedYear.toString(),
                                  style: const TextStyle(
                                    fontSize: 14, // Reduced
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.3, // Reduced
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _changeYear(1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8), // Reduced
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18, // Reduced
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10), // Reduced from 12

                // Month Selector with max rounding
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Month',
                        style: TextStyle(
                          fontSize: 11, // Reduced
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3, // Reduced
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced from 6
                      Container(
                        height: kControlHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(
                              kRadiusFull), // MAX ROUNDING
                          border: Border.all(color: kGlassBorder),
                        ),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMonth,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white.withOpacity(0.7),
                                size: 20, // Reduced
                              ),
                              style: const TextStyle(
                                fontSize: 13, // Reduced
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1, // Reduced
                              ),
                              dropdownColor: const Color(0xFF1A1A1A),
                              borderRadius:
                                  BorderRadius.circular(kRadiusMedium),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectMonth(newValue);
                                }
                              },
                              items: [
                                'All',
                                ..._months
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12), // Reduced
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 13, // Reduced
                                        color: Colors.white.withOpacity(0.9),
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

            const SizedBox(height: 12), // Reduced

            // Alphabet Selector - COMPACT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name Starts With',
                      style: TextStyle(
                        fontSize: 11, // Reduced
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3, // Reduced
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 6), // Reduced from 8
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
                          margin: const EdgeInsets.only(right: 6), // Reduced
                          decoration: BoxDecoration(
                            color: isSelected
                                ? kPrimaryRed.withOpacity(0.3)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(
                                kRadiusFull), // MAX ROUNDING
                            border: Border.all(
                              color: isSelected ? kPrimaryRed : kGlassBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 13, // Reduced
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.8),
                                letterSpacing: 0.1, // Reduced
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

            const SizedBox(height: 10), // Reduced from 12

            // Active Filter Display with max rounding
            Container(
              padding: kChipPadding,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius:
                    BorderRadius.circular(kRadiusFull), // MAX ROUNDING
                border: Border.all(color: kGlassBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.filter_alt,
                        size: 14, // Reduced
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8), // Reduced
                      Text(
                        'Showing: $_selectedMonth $_selectedYear${_selectedLetter != 'All' ? ' • $_selectedLetter' : ''}',
                        style: TextStyle(
                          fontSize: 11, // Reduced
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1, // Reduced
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
    );
  }
}
