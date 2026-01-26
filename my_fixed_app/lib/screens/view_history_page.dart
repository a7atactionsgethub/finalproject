import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../widgets/history_filter_widget.dart';
import '../widgets/gatepass_card_widget.dart';
import '../themes/app_theme.dart';

class ViewHistoryScreen extends StatefulWidget {
  const ViewHistoryScreen({super.key});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = DateFormat('MMM').format(DateTime.now());
  String _selectedLetter = 'All';
  List<Map<String, dynamic>> _gatepasses = [];
  bool _isLoading = true;

  // ⭐ Add ScrollController and FilterKey
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<HistoryFilterWidgetState> _filterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadAllGatepasses();
    // ⭐ Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // ⭐ Clean up scroll listener
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ⭐ Auto-collapse on scroll
  void _onScroll() {
    if (_scrollController.hasClients && _scrollController.offset > 10) {
      _filterKey.currentState?.collapseFilter();
    }
  }

  Future<void> _loadAllGatepasses() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('gatepasses')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      print('📡 Loaded ${snapshot.docs.length} documents');

      final List<Map<String, dynamic>> allGatepasses = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        DateTime? date = _parseDateTime(data['createdAt']) ??
            _parseDateTime(data['outTime']) ??
            _parseDateTime(data['date']) ??
            _parseDateTime(data['timestamp']);

        if (date == null) {
          print('⚠️ Skipping document ${doc.id} - no valid date found');
          continue;
        }

        final month3Letter = DateFormat('MMM').format(date);
        final monthFull = DateFormat('MMMM').format(date);

        allGatepasses.add({
          'id': doc.id,
          'name': data['studentName'] ??
              data['name'] ??
              data['student'] ??
              'Unknown',
          'roll': data['rollNumber'] ??
              data['roll'] ??
              data['studentId'] ??
              'Unknown',
          'department':
              data['department'] ?? data['dept'] ?? data['branch'] ?? 'Unknown',
          'reason': data['reason'] ??
              data['purpose'] ??
              data['visitReason'] ??
              'No reason',
          'status': data['status'] ?? data['approvalStatus'] ?? 'Unknown',
          'date': date,
          'month3Letter': month3Letter,
          'monthFull': monthFull,
          'year': date.year,
          'outTime': _formatTime(data['outTime']),
          'inTime': _formatTime(data['inTime']),
        });
      }

      setState(() {
        _gatepasses = allGatepasses;
        _isLoading = false;
      });

      _printAvailableMonths();
    } catch (e) {
      print('❌ Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _printAvailableMonths() {
    final months = <String>{};
    final years = <int>{};

    for (final pass in _gatepasses) {
      months.add(pass['month3Letter'] as String);
      years.add(pass['year'] as int);
    }

    print('📅 Available months: ${months.toList()}');
    print('📅 Available years: ${years.toList()}');

    if (_gatepasses.isNotEmpty) {
      print(
          '📊 Sample date: ${DateFormat('MMMM dd, yyyy').format(_gatepasses.first['date'])}');
    }
  }

  void _onFilterChanged(int year, String month, String letter) {
    print('🔄 Filter: $year, $month, $letter');
    setState(() {
      _selectedYear = year;
      _selectedMonth = month;
      _selectedLetter = letter;
    });
  }

  List<Map<String, dynamic>> _getFilteredData() {
    if (_gatepasses.isEmpty) return [];

    print(
        '🔍 Filtering with: $_selectedMonth $_selectedYear, Letter: $_selectedLetter');

    List<Map<String, dynamic>> filtered = [];

    for (final pass in _gatepasses) {
      final passMonth = pass['month3Letter'] as String;
      final passYear = pass['year'] as int;
      final name = pass['name'] as String;

      if (_gatepasses.length <= 10) {
        print('📝 Checking: $name - $passMonth $passYear');
      }

      if (_selectedMonth == 'All') {
        if (passYear != _selectedYear) {
          continue;
        }
      } else {
        if (passYear != _selectedYear || passMonth != _selectedMonth) {
          continue;
        }
      }

      if (_selectedLetter != 'All') {
        if (!name
            .trim()
            .toUpperCase()
            .startsWith(_selectedLetter.toUpperCase())) {
          continue;
        }
      }

      filtered.add(pass);
    }

    print('✅ Found ${filtered.length} matching gatepasses');
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();

    return Scaffold(
      body: Container(
        decoration: AppDecorations.backgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      decoration:
                          AppDecorations.glassContainer(borderRadius: 100),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: AppTheme.textSecondary),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Gatepass History',
                        style: AppTextStyles.headerLarge
                            .copyWith(color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration:
                          AppDecorations.glassContainer(borderRadius: 100),
                      child: IconButton(
                        icon: Icon(Icons.settings_outlined,
                            color: AppTheme.textSecondary),
                        onPressed: () => context.go('/settings'),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Filter Widget - ⭐ Added key
                HistoryFilterWidget(
                  key: _filterKey,
                  onFilterChanged: _onFilterChanged,
                  initialYear: _selectedYear,
                  initialMonth: _selectedMonth,
                  initialLetter: _selectedLetter,
                  resultCount: filteredData.length,
                ),

                // Main Content
                Expanded(
                  child: _isLoading
                      ? Center(child: AppWidgetStyles.loadingWidget())
                      : _gatepasses.isEmpty
                          ? _buildNoDataState()
                          : filteredData.isEmpty
                              ? _buildNoResultsState()
                              : _buildGatepassList(filteredData),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        decoration: AppDecorations.glassContainer(
          borderRadius: 20,
          color: AppTheme.glassColor,
          borderColor: AppTheme.glassBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.buttonGradient),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.search_off, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'No Gatepass Data',
              style: AppTextStyles.headerMedium
                  .copyWith(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              'There are no gatepasses in the system yet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'New gatepasses will appear here once created.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppTheme.textTertiary),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.buttonGradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _loadAllGatepasses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Refresh',
                    style: AppTextStyles.buttonMedium
                        .copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        decoration: AppDecorations.glassContainer(
          borderRadius: 20,
          color: AppTheme.glassColor,
          borderColor: AppTheme.glassBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.buttonGradient),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.filter_alt_off, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: AppTextStyles.headerMedium
                  .copyWith(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedMonth == 'All'
                  ? 'No gatepasses found for $_selectedYear'
                  : 'No gatepasses found for ${_getFullMonthName(_selectedMonth)} $_selectedYear',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filter settings',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppTheme.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatepassList(List<Map<String, dynamic>> filteredData) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final pass in filteredData) {
      final dateKey = DateFormat('MMMM dd, yyyy').format(pass['date']);
      grouped.putIfAbsent(dateKey, () => []).add(pass);
    }

    final dates = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMMM dd, yyyy').parse(a);
          final dateB = DateFormat('MMMM dd, yyyy').parse(b);
          return dateB.compareTo(dateA);
        } catch (_) {
          return b.compareTo(a);
        }
      });

    return ListView(
      controller: _scrollController, // ⭐ Added controller
      children: dates.map((date) {
        final passes = grouped[date]!;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppDecorations.glassContainer(borderRadius: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.buttonGradient),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: AppTextStyles.headerSmall
                          .copyWith(color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Text(
                        '${passes.length} ${passes.length == 1 ? 'entry' : 'entries'}',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: passes.map((pass) => _buildPassCard(pass)).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ⭐ Now uses the widget!
  Widget _buildPassCard(Map<String, dynamic> pass) {
    return GatepassCardWidget(
      name: pass['name'],
      roll: pass['roll'],
      department: pass['department'],
      reason: pass['reason'],
      status: pass['status'],
      outTime: pass['outTime'],
      inTime: pass['inTime'],
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  String _formatTime(dynamic value) {
    try {
      final dt = _parseDateTime(value);
      return dt != null ? DateFormat('hh:mm a').format(dt) : '—';
    } catch (_) {
      return '—';
    }
  }

  String _getFullMonthName(String shortMonth) {
    switch (shortMonth) {
      case 'Jan':
        return 'January';
      case 'Feb':
        return 'February';
      case 'Mar':
        return 'March';
      case 'Apr':
        return 'April';
      case 'May':
        return 'May';
      case 'Jun':
        return 'June';
      case 'Jul':
        return 'July';
      case 'Aug':
        return 'August';
      case 'Sep':
        return 'September';
      case 'Oct':
        return 'October';
      case 'Nov':
        return 'November';
      case 'Dec':
        return 'December';
      case 'All':
        return 'All Months';
      default:
        return shortMonth;
    }
  }
}
