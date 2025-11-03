import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 2024',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: '1. Introduction',
              content:
                  'Welcome to Belleza Cosmetics. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '2. Information We Collect',
              content:
                  'We collect personal information that you voluntarily provide to us when you register on the application, express an interest in obtaining information about us or our products and services, when you participate in activities on the application, or otherwise when you contact us.\n\nThe personal information we collect may include the following:\n• Name and contact data\n• Payment information\n• Business information\n• Device and usage data',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '3. How We Use Your Information',
              content:
                  'We use the information we collect or receive:\n• To facilitate account creation and authentication\n• To send administrative information to you\n• To fulfill and manage your orders\n• To post testimonials with your consent\n• To deliver targeted advertising to you\n• To protect our services and maintain security',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '4. Sharing Your Information',
              content:
                  'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '5. Data Security',
              content:
                  'We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, please also remember that we cannot guarantee that the internet itself is 100% secure.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '6. Your Privacy Rights',
              content:
                  'In some regions, you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time. If you have questions or comments about your privacy rights, you may email us at privacy@belleza.com.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '7. Updates to This Policy',
              content:
                  'We may update this privacy policy from time to time. The updated version will be indicated by an updated "Last Updated" date and the updated version will be effective as soon as it is accessible.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '8. Contact Us',
              content:
                  'If you have questions or comments about this policy, you may email us at support@belleza.com or contact us by phone at +213 123 456 789.',
            ),
            const SizedBox(height: 32),

            // Accept Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3CB371),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'I Understand',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 4),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3CB371),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Product'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}