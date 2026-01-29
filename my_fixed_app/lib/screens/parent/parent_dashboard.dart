import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/gatepass_card_widget.dart';
import '../../themes/app_theme.dart';

class WardHistoryScreen extends StatefulWidget {
  const WardHistoryScreen({super.key});

  @override
  State<WardHistoryScreen> createState() => _WardHistoryScreenState();
}

class _WardHistoryScreenState extends State<WardHistoryScreen> {
  List<Map<String, dynamic>> _wardGatepasses = [];
  bool _isLoading = true;
  Map<String, dynamic>? _wardInfo;
  String? _wardStudentId;

  @override
  void initState() {
    super.initState();
    _loadWardInfoAndHistory();
  }

  Future<void> _loadWardInfoAndHistory() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 1. Get parent document to find ward's studentId
      final parentDoc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(currentUser.uid)
          .get();

      if (!parentDoc.exists) {
        setState(() => _isLoading = false);
        return;
      }

      final parentData = parentDoc.data()!;
      _wardStudentId = parentData['wardStudentId'] as String?;

      if (_wardStudentId == null || _wardStudentId!.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      // 2. Get ward student info
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(_wardStudentId)
          .get();

      if (studentDoc.exists) {
        final studentData = studentDoc.data()!;
        _wardInfo = {
          'name': studentData['name'] ?? 'Unknown',
          'rollNumber': studentData['rollNumber'] ?? 'Unknown',
          'room': studentData['room'] ?? 'Unknown',
          'department': studentData['department'] ?? 'Unknown',
          'phone': studentData['phone'] ?? 'Unknown',
          'email': studentData['email'] ?? 'Unknown',
        };
      }

      // 3. Get ward's gate passes
      await _loadGatepasses();
    } catch (e) {
      print('❌ Error loading ward info: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadGatepasses() async {
    try {
      if (_wardStudentId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final gatepassSnapshot = await FirebaseFirestore.instance
          .collection('gatepasses')
          .where('studentId', isEqualTo: _wardStudentId)
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> wardGatepasses = [];

      for (final doc in gatepassSnapshot.docs) {
        final data = doc.data();

        DateTime? date = _parseDateTime(data['createdAt']) ??
            _parseDateTime(data['outTime']) ??
            _parseDateTime(data['date']);

        if (date == null) continue;

        wardGatepasses.add({
          'id': doc.id,
          'name': _wardInfo?['name'] ?? 'Ward',
          'roll': _wardInfo?['rollNumber'] ?? 'Unknown',
          'department': _wardInfo?['department'] ?? 'Unknown',
          'reason': data['reason'] ?? 'No reason provided',
          'status': data['status'] ?? 'Pending',
          'date': date,
          'outTime': _formatTime(data['outTime']),
          'inTime': _formatTime(data['inTime']),
          'approvedBy': data['approvedBy'] ?? 'Admin',
          'checkInTime': _formatTime(data['checkInTime']),
          'checkOutTime': _formatTime(data['checkOutTime']),
          'duration': data['duration'] ?? '—',
          'location': data['location'] ?? '—',
          'notes': data['notes'] ?? '—',
        });
      }

      setState(() {
        _wardGatepasses = wardGatepasses;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading gatepasses: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.backgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.buttonGradient,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ward\'s History',
                                style: AppTextStyles.headerLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                              if (_wardInfo != null)
                                Text(
                                  _wardInfo!['name'],
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              setState(() => _isLoading = true);
                              _loadGatepasses();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ward Info Card
                    if (_wardInfo != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Roll No: ${_wardInfo!['rollNumber']}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Room: ${_wardInfo!['room']} • Dept: ${_wardInfo!['department']}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  if (_wardInfo!['phone'] != 'Unknown')
                                    Text(
                                      'Phone: ${_wardInfo!['phone']}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Stats Summary
                    if (_wardGatepasses.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                                'Total', _wardGatepasses.length.toString()),
                            _buildStatItem(
                              'Approved',
                              _wardGatepasses
                                  .where((g) => g['status'] == 'Approved')
                                  .length
                                  .toString(),
                              color: AppTheme.statusApproved,
                            ),
                            _buildStatItem(
                              'Pending',
                              _wardGatepasses
                                  .where((g) => g['status'] == 'Pending')
                                  .length
                                  .toString(),
                              color: AppTheme.statusPending,
                            ),
                            _buildStatItem(
                              'Rejected',
                              _wardGatepasses
                                  .where((g) => g['status'] == 'Rejected')
                                  .length
                                  .toString(),
                              color: AppTheme.statusRejected,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: _isLoading
                    ? Center(child: AppWidgetStyles.loadingWidget())
                    : _wardGatepasses.isEmpty
                        ? _buildNoDataState()
                        : _buildGatepassList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headerMedium.copyWith(
            color: color ?? Colors.white,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        decoration: AppDecorations.glassContainer(
          borderRadius: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.history_toggle_off_rounded,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Gatepass History',
              style: AppTextStyles.headerMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _wardInfo != null
                  ? '${_wardInfo!['name']} hasn\'t applied for any gate passes yet.'
                  : 'No gate pass history available.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeightMedium,
              child: ElevatedButton(
                onPressed: _loadGatepasses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Refresh',
                  style: AppTextStyles.buttonMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatepassList() {
    // Group gatepasses by month-year
    final Map<String, List<Map<String, dynamic>>> groupedByMonth = {};

    for (final pass in _wardGatepasses) {
      final monthYear = DateFormat('MMMM yyyy').format(pass['date']);
      groupedByMonth.putIfAbsent(monthYear, () => []).add(pass);
    }

    // Sort months in descending order
    final sortedMonths = groupedByMonth.keys.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMMM yyyy').parse(a);
          final dateB = DateFormat('MMMM yyyy').parse(b);
          return dateB.compareTo(dateA);
        } catch (_) {
          return b.compareTo(a);
        }
      });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.glassContainer(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Gate Passes',
                    style: AppTextStyles.headerSmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${_wardGatepasses.length} total entries',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ward History',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Grouped by Month
        ...sortedMonths.map((monthYear) {
          final passes = groupedByMonth[monthYear]!;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: AppDecorations.glassContainer(borderRadius: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthYear,
                        style: AppTextStyles.headerSmall.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${passes.length} ${passes.length == 1 ? 'entry' : 'entries'}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Gatepass List
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children:
                        passes.map((pass) => _buildPassCard(pass)).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPassCard(Map<String, dynamic> pass) {
    final isApproved = pass['status'] == 'Approved';
    final isRejected = pass['status'] == 'Rejected';
    final statusColor = isApproved
        ? AppTheme.statusApproved
        : isRejected
            ? AppTheme.statusRejected
            : AppTheme.statusPending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGatepassDetails(pass),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Status Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isApproved
                        ? Icons.check_circle_rounded
                        : isRejected
                            ? Icons.cancel_rounded
                            : Icons.pending_rounded,
                    size: 20,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pass['reason'],
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              pass['status'],
                              style: AppTextStyles.bodySmall.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a')
                            .format(pass['date']),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (pass['outTime'] != '—' && pass['inTime'] != '—')
                        Text(
                          'Out: ${pass['outTime']} • In: ${pass['inTime']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGatepassDetails(Map<String, dynamic> pass) {
    final isApproved = pass['status'] == 'Approved';
    final isRejected = pass['status'] == 'Rejected';
    final statusColor = isApproved
        ? AppTheme.statusApproved
        : isRejected
            ? AppTheme.statusRejected
            : AppTheme.statusPending;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(AppSpacing.screenPadding),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppDecorations.glassContainer(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gate Pass Details',
                  style: AppTextStyles.headerMedium.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: AppDecorations.statusBadgeContainer(statusColor),
                  child: Text(
                    pass['status'],
                    style: AppTextStyles.statusBadge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            Divider(color: AppTheme.dividerColor),
            const SizedBox(height: AppSpacing.elementSpacing),

            // Details
            _buildDetailRow(
                'Date', DateFormat('EEEE, MMMM dd, yyyy').format(pass['date'])),
            _buildDetailRow('Time', DateFormat('hh:mm a').format(pass['date'])),
            _buildDetailRow('Reason', pass['reason']),
            _buildDetailRow(
                'Check Out', pass['checkOutTime'] ?? pass['outTime'] ?? '—'),
            _buildDetailRow(
                'Check In', pass['checkInTime'] ?? pass['inTime'] ?? '—'),
            _buildDetailRow('Duration', pass['duration']),
            _buildDetailRow('Approved By', pass['approvedBy']),
            if (pass['location'] != null && pass['location'] != '—')
              _buildDetailRow('Location', pass['location']),
            if (pass['notes'] != null && pass['notes'] != '—')
              _buildDetailRow('Notes', pass['notes']),

            const SizedBox(height: AppSpacing.elementSpacing),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeightMedium,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSpacing.buttonHeightMedium / 2),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: AppTextStyles.buttonMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
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
}
