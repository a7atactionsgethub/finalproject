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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.glassContainer(borderRadius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status Badge
          Row(
            children: [
              // Status indicator dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.headerSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: AppDecorations.statusBadgeContainer(
                    _getStatusColor(status)),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.statusBadge.copyWith(
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Roll and Department in one row
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                roll,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.school_outlined,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
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

          const SizedBox(height: 12),

          // Reason - plain text, no box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.description_outlined,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason',
                      style: AppTextStyles.labelTertiary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reason,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Times Section
          Row(
            children: [
              // Departure
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 14,
                          color: AppTheme.statusOut,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DEPARTURE',
                          style: AppTextStyles.labelTertiary.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      outTime,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Expected Return
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.login_rounded,
                          size: 14,
                          color: AppTheme.statusApproved,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'EXPECTED RETURN',
                          style: AppTextStyles.labelTertiary.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inTime,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Bottom colored indicator line
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(status),
                  _getStatusColor(status).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
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
        return AppTheme.statusApproved;
      default:
        return AppTheme.textSecondary;
    }
  }
}
