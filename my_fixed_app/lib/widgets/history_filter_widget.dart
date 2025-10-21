import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryFilterWidget extends StatefulWidget {
  final Function(int year, String month, String letter) onFilterChanged;
  final int initialYear;
  final String initialMonth;
  final String initialLetter;
  final Color glassWhite;
  final Color glassBorder;

  const HistoryFilterWidget({
    Key? key,
    required this.onFilterChanged,
    required this.initialYear,
    required this.initialMonth,
    required this.initialLetter,
    required this.glassWhite,
    required this.glassBorder,
  }) : super(key: key);

  @override
  _HistoryFilterWidgetState createState() => _HistoryFilterWidgetState();
}

class _HistoryFilterWidgetState extends State<HistoryFilterWidget> {
  late int _selectedYear;
  late String _selectedMonth;
  late String _selectedLetter;

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<String> _alphabets = ['All', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

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
    _notifyFilterChange();
  }

  void _selectMonth(String month) {
    setState(() {
      _selectedMonth = month;
    });
    _notifyFilterChange();
  }

  void _selectLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
    });
    _notifyFilterChange();
  }

  void _clearFilters() {
    setState(() {
      _selectedYear = DateTime.now().year;
      _selectedMonth = 'All';
      _selectedLetter = 'All';
    });
    _notifyFilterChange();
  }

  void _notifyFilterChange() {
    widget.onFilterChanged(_selectedYear, _selectedMonth, _selectedLetter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.glassWhite,
        borderRadius: BorderRadius.circular(24), // Main card back to normal
        border: Border.all(color: widget.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Clear button and active filters
            Row(
              children: [
                // Active filters display
                Expanded(
                  child: Container(
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18), // INSIDE: Fully rounded
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.white.withOpacity(0.6), size: 14),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${_selectedMonth != 'All' ? _selectedMonth.substring(0, 3) : 'All'} • $_selectedYear${_selectedLetter != 'All' ? ' • $_selectedLetter' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: 8),
                
                // Clear button
                GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18), // INSIDE: Fully rounded
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Year and Month side by side
            Row(
              children: [
                // Year Selector
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18), // INSIDE: Fully rounded
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.7), size: 16),
                              onPressed: () => _changeYear(-1),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _selectedYear.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7), size: 16),
                              onPressed: () => _changeYear(1),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 8),
                
                // Month Selector
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Month',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18), // INSIDE: Fully rounded
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMonth.length > 3 ? _selectedMonth.substring(0, 3) : _selectedMonth,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.7), size: 16),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: Color(0xFF2D1B1B),
                              borderRadius: BorderRadius.circular(18), // INSIDE: Fully rounded
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectMonth(newValue == 'All' ? 'All' : _getFullMonthName(newValue));
                                }
                              },
                              items: ['All', ..._months].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.9),
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

            SizedBox(height: 12),

            // Alphabet Selector - Circular cards
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 6),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _alphabets.length,
                    itemBuilder: (context, index) {
                      final letter = _alphabets[index];
                      final isSelected = _selectedLetter == letter;

                      return GestureDetector(
                        onTap: () => _selectLetter(letter),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle, // Perfect circles
                            border: Border.all(
                              color: isSelected 
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: Colors.white.withOpacity(isSelected ? 0.9 : 0.7),
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
          ],
        ),
      ),
    );
  }

  String _getFullMonthName(String shortMonth) {
    switch (shortMonth) {
      case 'Jan': return 'January';
      case 'Feb': return 'February';
      case 'Mar': return 'March';
      case 'Apr': return 'April';
      case 'May': return 'May';
      case 'Jun': return 'June';
      case 'Jul': return 'July';
      case 'Aug': return 'August';
      case 'Sep': return 'September';
      case 'Oct': return 'October';
      case 'Nov': return 'November';
      case 'Dec': return 'December';
      default: return shortMonth;
    }
  }
}