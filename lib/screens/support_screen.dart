import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/animations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: themeProvider.getTextColor()),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Help & Support',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Contact Support Section
                          FadeInSlide(delay: 0.0, child: _buildSectionTitle(themeProvider, 'Contact Us')),
                          const SizedBox(height: 16),
                          FadeInSlide(
                            delay: 0.1,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: themeProvider.getCardBackgroundColor(),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: themeProvider.getBorderColor()),
                              ),
                              child: Column(
                                children: [
                                  _buildContactOption(
                                    themeProvider,
                                    Icons.email_outlined,
                                    'Email Support',
                                    'support@currensee.com',
                                    () {},
                                  ),
                                  const Divider(),
                                  _buildContactOption(
                                    themeProvider,
                                    Icons.chat_bubble_outline,
                                    'Live Chat',
                                    'Available 24/7',
                                    () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // FAQs Section
                          FadeInSlide(delay: 0.2, child: _buildSectionTitle(themeProvider, 'Frequently Asked Questions')),
                          const SizedBox(height: 16),
                          FadeInSlide(
                            delay: 0.3,
                            child: _buildFAQItem(
                              themeProvider,
                              'How do I change my default currency?',
                              'Go to the Settings tab and select "Default Currency" under Account Settings. Choose your preferred currency from the list.',
                            ),
                          ),
                          FadeInSlide(
                            delay: 0.4,
                            child: _buildFAQItem(
                              themeProvider,
                              'Are the exchange rates real-time?',
                              'Yes, we update our exchange rates every minute using reliable financial data sources to ensure accuracy.',
                            ),
                          ),
                          FadeInSlide(
                            delay: 0.5,
                            child: _buildFAQItem(
                              themeProvider,
                              'How do I set a rate alert?',
                              'Navigate to the Profile tab and tap on "Alerts". Click the "+" button to create a new alert for a specific currency pair and target rate.',
                            ),
                          ),
                          FadeInSlide(
                            delay: 0.6,
                            child: _buildFAQItem(
                              themeProvider,
                              'Is my data secure?',
                              'Absolutely. We use industry-standard encryption to protect your personal information and transaction history.',
                            ),
                          ),
                          const SizedBox(height: 32),

                          // User Guides Section
                          FadeInSlide(delay: 0.7, child: _buildSectionTitle(themeProvider, 'User Guides')),
                          const SizedBox(height: 16),
                          FadeInSlide(delay: 0.8, child: _buildGuideItem(themeProvider, 'Getting Started with CurrenSee')),
                          FadeInSlide(delay: 0.9, child: _buildGuideItem(themeProvider, 'Understanding Currency Charts')),
                          FadeInSlide(delay: 1.0, child: _buildGuideItem(themeProvider, 'Managing Your Profile')),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeProvider themeProvider, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: themeProvider.getTextColor(),
      ),
    );
  }

  Widget _buildContactOption(
    ThemeProvider themeProvider,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.getAccentColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeProvider.getAccentColor()),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: themeProvider.getTextColor(),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: themeProvider.getSecondaryTextColor(),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: themeProvider.getSecondaryTextColor()),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(ThemeProvider themeProvider, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.getBorderColor()),
      ),
      child: Builder(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.getTextColor(),
              ),
            ),
            iconColor: themeProvider.getAccentColor(),
            collapsedIconColor: themeProvider.getTextColor(),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  answer,
                  style: TextStyle(
                    color: themeProvider.getSecondaryTextColor(),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem(ThemeProvider themeProvider, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: themeProvider.getCardBackgroundColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: themeProvider.getBorderColor()),
        ),
        leading: Icon(Icons.article_outlined, color: themeProvider.getAccentColor()),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.getTextColor(),
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: themeProvider.getSecondaryTextColor()),
        onTap: () {
          // Navigate to guide details (placeholder)
        },
      ),
    );
  }
}
