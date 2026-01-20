import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_theme.dart';
import '../widgets/history_filter_widget.dart'; // Keeping your existing widget

class ViewHistoryScreen extends StatefulWidget {
  const ViewHistoryScreen({super.key});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  // Default to current date
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  String _selectedLetter = 'All';

  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onFilterChanged(int year, String month, String letter) {
    setState(() {
      _selectedYear = year;
      _selectedMonth = month;
      _selectedLetter = letter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppDecorations.backgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== Header ==========
                Row(
                  children: [
                    AppWidgetStyles.backButton(context),
                    const SizedBox(width: AppSpacing.elementSpacing),
                    Expanded(
                      child: Text(
                        'Gatepass History',
                        style: AppTextStyles.headerMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Settings Icon
                    Container(
                      decoration: AppDecorations.glassContainer(borderRadius: 16),
                      child: IconButton(
                        icon: Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
                        onPressed: () => context.go('/settings'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.sectionSpacing),

                // ========== Filter Widget ==========
                // We pass the dynamic AppTheme colors to your existing widget
                HistoryFilterWidget(
                  onFilterChanged: _onFilterChanged,
                  initialYear: _selectedYear,
                  initialMonth: _selectedMonth,
                  initialLetter: _selectedLetter,
                  glassWhite: AppTheme.glassColor,
                  glassBorder: AppTheme.glassBorder,
                ),

                const SizedBox(height: AppSpacing.elementSpacing),

                // ========== History Content ==========
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('gatepasses')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AppWidgetStyles.loadingWidget();
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Something went wrong', 
                            style: AppTextStyles.bodyMedium.copyWith(color: AppTheme.statusRejected)
                          )
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return AppWidgetStyles.emptyStateWidget(
                          title: "No Records",
                          message: "No gatepass history found in database."
                        );
                      }

                      // Filter and group data
                      final groupedByDate = _filterAndGroupData(
                        snapshot.data!.docs,
                        _selectedYear,
                        _selectedMonth,
                        _selectedLetter,
                      );

                      if (groupedByDate.isEmpty) {
                         return AppWidgetStyles.emptyStateWidget(
                          title: "No Matches",
                          message: "No records found for $_selectedMonth $_selectedYear with filter '$_selectedLetter'."
                        );
                      }

                      final sortedDates = groupedByDate.keys.toList()
                        ..sort((a, b) {
                          // Sort date strings safely
                          try {
                            final dateA = DateFormat('MMMM dd, yyyy').parse(a);
                            final dateB = DateFormat('MMMM dd, yyyy').parse(b);
                            return dateB.compareTo(dateA);
                          } catch (e) {
                            return 0;
                          }
                        });

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          final date = sortedDates[index];
                          final passes = groupedByDate[date]!;
                          return _buildDateSection(date, passes);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== Logic & Filtering ==========

  Map<String, List<Map<String, dynamic>>> _filterAndGroupData(
    List<QueryDocumentSnapshot<Object?>> docs,
    int year,
    String month,
    String letter,
  ) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final doc in docs) {
      try {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        final createdAt = _parseDateTime(data['createdAt']);
        if (createdAt == null) continue;

        // 1. Date Filter
        // Check if the record matches selected Year and Month
        if (createdAt.year != year) continue;
        if (DateFormat('MMMM').format(createdAt) != month) continue;

        final name = (data['studentName'] ?? data['name'] ?? 'Unknown').toString();
        
        // 2. Alphabet Filter (Fixed Logic)
        if (letter != 'All') {
          // Case insensitive check
          if (name.isEmpty || !name.toUpperCase().startsWith(letter.toUpperCase())) {
            continue;
          }
        }

        // Data Preparation
        final roll = data['rollNumber'] ?? data['roll'] ?? 'Unknown';
        final dept = data['department'] ?? data['dept'] ?? 'Unknown';
        final reason = data['reason'] ?? data['purpose'] ?? data['visitReason'] ?? 'N/A';
        final inTime = _formatTime(data['inTime']);
        final outTime = _formatTime(data['outTime']);
        final dateKey = DateFormat('MMMM dd, yyyy').format(createdAt);

        grouped.putIfAbsent(dateKey, () => []).add({
          'name': name,
          'roll': roll.toString(),
          'department': dept.toString(),
          'reason': reason.toString(),
          'inTime': inTime,
          'outTime': outTime,
        });
      } catch (e) {
        print("Error processing doc ${doc.id}: $e");
        continue;
      }
    }

    return grouped;
  }

  // ========== Sub-Widgets ==========

  Widget _buildDateSection(String date, List<Map<String, dynamic>> passes) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.elementSpacing),
      decoration: AppDecorations.glassContainer(
        borderColor: AppTheme.glassBorder,
      ),
      clipBehavior: Clip.antiAlias, // Ensures child gradient respects border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.buttonGradient, // Use theme gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              date,
              style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
            ),
          ),

          // Passes List
          Padding(
            padding: const EdgeInsets.all(AppSpacing.elementSpacing),
            child: Column(
              children: passes.map((pass) => _buildPassCard(pass)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassCard(Map<String, dynamic> pass) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          // Name and Roll
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: AppDecorations.iconContainer(AppTheme.primaryColor),
                child: Icon(Icons.person, size: 16, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pass['name'] ?? 'Unknown',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      pass['roll'] ?? 'Unknown',
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Divider(color: AppTheme.dividerColor, height: 1),
          const SizedBox(height: 12),

          // Details Row
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(Icons.school, "Dept", pass['department']),
              ),
              Expanded(
                child: _buildInfoColumn(Icons.article, "Reason", pass['reason']),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time Row (Glass Badge style)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo('OUT', pass['outTime'], AppTheme.statusOut),
                Container(width: 1, height: 20, color: AppTheme.dividerColor),
                _buildTimeInfo('IN', pass['inTime'], AppTheme.statusApproved),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelTertiary),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(color: AppTheme.textPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String label, String time, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ========== Helpers ==========

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is Timestamp) return value.toDate().toLocal();
      if (value is String) {
        // Try parsing ISO first
        try {
          return DateTime.parse(value).toLocal();
        } catch (_) {
          // If custom format, try that (optional)
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
}