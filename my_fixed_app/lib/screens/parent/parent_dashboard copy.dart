import 'package:flutter/material.dart';
import 'package:your_app/themes/app_theme.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.backgroundDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parent Dashboard',
                          style: AppTextStyles.headerLarge.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Welcome back!',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: AppDecorations.glassContainer(
                            borderRadius: 100,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              // Navigate to notifications
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.smallSpacing),
                        Container(
                          decoration: AppDecorations.glassContainer(
                            borderRadius: 100,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.person_outline,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              // Navigate to profile
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Ward Info Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: AppDecorations.glassContainer(),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.smallSpacing),
                        decoration: AppDecorations.iconContainer(
                          AppTheme.primaryColor,
                        ),
                        child: Icon(
                          Icons.person,
                          size: AppSpacing.iconSizeLarge,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.elementSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: AppTextStyles.headerSmall.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.microSpacing),
                            Text(
                              'Roll No: 2023001 | Room: A-101',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              'Department: Computer Science',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Leaves Used',
                        '15',
                        Icons.logout,
                        AppTheme.statusRejected,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.elementSpacing),
                    Expanded(
                      child: _buildStatCard(
                        'Leaves Remaining',
                        '5',
                        Icons.event_available,
                        AppTheme.statusApproved,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Leave Counter
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: AppDecorations.glassContainer(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timeline,
                            size: AppSpacing.iconSizeMedium,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: AppSpacing.smallSpacing),
                          Text(
                            'Monthly Leave Counter',
                            style: AppTextStyles.headerSmall.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.elementSpacing),
                      Text(
                        '20 leaves maximum',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.elementSpacing),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.glassColor,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.statusRejected.withOpacity(0.7),
                                    AppTheme.statusRejected.withOpacity(0.4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.smallSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '15 Used',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppTheme.statusRejected,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '5 Remaining',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppTheme.statusApproved,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Recent History Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent History',
                      style: AppTextStyles.headerMedium.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WardHistoryScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'View All',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.smallSpacing),

                // Recent History List
                _buildHistoryList(),

                const SizedBox(height: AppSpacing.sectionSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.glassContainer(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.smallSpacing),
                decoration: AppDecorations.iconContainer(color),
                child: Icon(
                  icon,
                  size: AppSpacing.iconSizeMedium,
                  color: color,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.headerLarge.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final historyItems = [
      {
        'date': '2024-03-15',
        'reason': 'Medical Appointment',
        'status': 'Approved',
        'time': '4 hours',
        'icon': Icons.medical_services,
      },
      {
        'date': '2024-03-10',
        'reason': 'Family Function',
        'status': 'Approved',
        'time': '8 hours',
        'icon': Icons.celebration,
      },
      {
        'date': '2024-03-05',
        'reason': 'Personal Work',
        'status': 'Rejected',
        'time': '6 hours',
        'icon': Icons.work_outline,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: historyItems.length,
      itemBuilder: (context, index) {
        final item = historyItems[index];
        final isApproved = item['status'] == 'Approved';

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.smallSpacing),
          decoration: AppDecorations.glassContainer(),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppSpacing.smallSpacing),
              decoration: AppDecorations.iconContainer(
                isApproved ? AppTheme.statusApproved : AppTheme.statusRejected,
              ),
              child: Icon(
                item['icon'] as IconData,
                size: AppSpacing.iconSizeMedium,
                color: isApproved
                    ? AppTheme.statusApproved
                    : AppTheme.statusRejected,
              ),
            ),
            title: Text(
              item['reason']!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${item['date']} • ${item['time']}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smallSpacing,
                vertical: AppSpacing.microSpacing,
              ),
              decoration: AppDecorations.statusBadgeContainer(
                isApproved ? AppTheme.statusApproved : AppTheme.statusRejected,
              ),
              child: Text(
                item['status']!,
                style: AppTextStyles.statusBadge.copyWith(
                  color: isApproved
                      ? AppTheme.statusApproved
                      : AppTheme.statusRejected,
                ),
              ),
            ),
            onTap: () {
              _showHistoryDetails(context, item);
            },
          ),
        );
      },
    );
  }

  void _showHistoryDetails(BuildContext context, Map<String, String> item) {
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
            Text(
              'Gate Pass Details',
              style: AppTextStyles.headerMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            Divider(color: AppTheme.dividerColor),
            const SizedBox(height: AppSpacing.elementSpacing),
            AppWidgetStyles.infoRow('Date', item['date']!),
            AppWidgetStyles.infoRow('Reason', item['reason']!),
            AppWidgetStyles.infoRow('Duration', item['time']!),
            AppWidgetStyles.infoRow('Status', item['status']!),
            AppWidgetStyles.infoRow('Approved By', 'Admin User'),
            AppWidgetStyles.infoRow('Check Out', '10:00 AM'),
            AppWidgetStyles.infoRow('Check In', '6:00 PM'),
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
}
