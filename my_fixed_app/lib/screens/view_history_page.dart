import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../widgets/history_filter_widget.dart';

class ViewHistoryScreen extends StatefulWidget {
  const ViewHistoryScreen({super.key});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  final Color _glassWhite = Colors.white.withOpacity(0.1);
  final Color _glassBorder = Colors.white.withOpacity(0.2);
  
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  String _selectedLetter = 'All';

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF2D1B1B),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back and Settings Icons
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _glassWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _glassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white.withOpacity(0.7)),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Gatepass History',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // Settings Icon
                    Container(
                      decoration: BoxDecoration(
                        color: _glassWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _glassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.settings_outlined,
                            color: Colors.white.withOpacity(0.7)),
                        onPressed: () {
                          context.go('/settings');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Filter Widget
                HistoryFilterWidget(
                  onFilterChanged: _onFilterChanged,
                  initialYear: _selectedYear,
                  initialMonth: _selectedMonth,
                  initialLetter: _selectedLetter,
                  glassWhite: _glassWhite,
                  glassBorder: _glassBorder,
                ),

                // History Content
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('gatepasses')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState();
                      }

                      if (snapshot.hasError) {
                        return _buildErrorCard('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyState(_selectedMonth, _selectedYear);
                      }

                      // Filter and group data
                      final groupedByDate = _filterAndGroupData(
                        snapshot.data!.docs,
                        _selectedYear,
                        _selectedMonth,
                        _selectedLetter,
                      );

                      if (groupedByDate.isEmpty) {
                        return _buildEmptyState(_selectedMonth, _selectedYear);
                      }

                      final sortedDates = groupedByDate.keys.toList()
                        ..sort((a, b) => b.compareTo(a));

                      return ListView(
                        children: sortedDates.map((date) {
                          final passes = groupedByDate[date]!;
                          return _buildDateSection(date, passes);
                        }).toList(),
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

        // Filter by selected year and month
        if (createdAt.year != year || 
            DateFormat('MMMM').format(createdAt) != month) {
          continue;
        }

        final name = data['studentName'] ?? data['name'] ?? 'Unknown';
        
        // Filter by alphabet if not 'All'
        if (letter != 'All') {
          if (name.toString().isEmpty || !name.toString().toUpperCase().startsWith(letter)) {
            continue;
          }
        }

        final roll = data['rollNumber'] ?? data['roll'] ?? 'Unknown';
        final dept = data['department'] ?? data['dept'] ?? 'Unknown';
        final reason = data['reason'] ?? data['purpose'] ?? data['visitReason'] ?? 'N/A';

        final inTime = _formatTime(data['inTime']);
        final outTime = _formatTime(data['outTime']);

        final dateKey = DateFormat('MMMM dd, yyyy').format(createdAt);

        grouped.putIfAbsent(dateKey, () => []).add({
          'name': name.toString(),
          'roll': roll.toString(),
          'department': dept.toString(),
          'reason': reason.toString(),
          'inTime': inTime,
          'outTime': outTime,
        });
      } catch (e) {
        // Skip invalid documents
        continue;
      }
    }

    return grouped;
  }

  Widget _buildDateSection(String date, List<Map<String, dynamic>> passes) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDC2626),
                  Color(0xFF991B1B),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // Passes List
          Padding(
            padding: const EdgeInsets.all(16),
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
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Name and Roll Number
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pass['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(Icons.badge_outlined, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Text(
                pass['roll'] ?? 'Unknown',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Department
          Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pass['department'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reason
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.description_outlined, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pass['reason'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time Information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeInfo('Out', pass['outTime'] ?? '—'),
              _buildTimeInfo('In', pass['inTime'] ?? '—'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.54),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: _glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _glassBorder),
        ),
        padding: const EdgeInsets.all(32),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white.withOpacity(0.7),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String month, int year) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_outlined,
              color: Colors.white.withOpacity(0.7),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No gatepass history',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No gatepasses found for $month $year',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Parse any date format from Firestore
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is Timestamp) return value.toDate().toLocal();
      if (value is String) {
        return DateTime.parse(value).toLocal();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Format time from Timestamp or String
  String _formatTime(dynamic value) {
    try {
      final dt = _parseDateTime(value);
      return dt != null ? DateFormat('hh:mm a').format(dt) : '—';
    } catch (_) {
      return '—';
    }
  }
}