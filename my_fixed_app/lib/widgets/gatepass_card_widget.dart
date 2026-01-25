// widgets/gatepass_card_widget.dart
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class GatepassCardWidget extends StatelessWidget {
  final String name;
  final String roll;
  final String department;
  final String reason;
  final String status;
  final String outTime;
  final String inTime;

  const GatepassCardWidget({
    super.key,
    required this.name,
    required this.roll,
    required this.department,
    required this.reason,
    required this.status,
    required this.outTime,
    required this.inTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        borderRadius: 12,
        color: AppTheme.glassColor,
        borderColor: AppTheme.glassBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: AppDecorations.statusBadgeContainer(
                  _getStatusColor(status),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Roll and Department
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Roll: $roll',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.school_outlined,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  department,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Reason
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.description_outlined,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reason,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Times
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.glassBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo('OUT', outTime),
                Container(
                  height: 20,
                  width: 1,
                  color: AppTheme.glassBorder,
                ),
                _buildTimeInfo('IN', inTime),
              ],
            ),
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
          style: AppTextStyles.bodySmall.copyWith(
            color: AppTheme.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.statusApproved;
      case 'pending':
        return AppTheme.statusPending;
      case 'rejected':
        return AppTheme.statusRejected;
      case 'out':
        return AppTheme.statusOut;
      case 'in':
        return const Color(0xFF8B5CF6); // Violet for IN status
      default:
        return AppTheme.textSecondary;
    }
  }
}
