import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'view_history_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App Bar with Three dots button
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white70,
                    ),
                    onSelected: (String value) {
                      if (value == 'View History') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewHistoryScreen()),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'View History',
                        child: Text(
                          'View History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    color: const Color(0xFF2A1A1A),
                  ),
                ),
              ),
            ),

            // Centered Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Section with Premium Font Style
                  Column(
                    children: [
                      Text(
                        'ROCKBOYS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'HOSTEL MANAGEMENT',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Glass Login Button
                      Container(
                        width: 220,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.go('/signin'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          ),
                          child: const Text(
                            'GET STARTED',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'Secure • Fast • Reliable',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Clean Bottom Section
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Text(
                    'Gate Pass Management System',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}