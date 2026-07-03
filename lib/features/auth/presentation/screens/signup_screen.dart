import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/features/auth/presentation/providers/auth_provider.dart';
import 'package:currensee/widgets/animations.dart';
import 'package:currensee/shared/widgets/custom_text_field.dart';
import 'package:currensee/shared/widgets/custom_button.dart';
import 'package:currensee/shared/widgets/glass_card.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms and conditions')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signup(name, email, password);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (!mounted) return;
      final errorMsg = authProvider.errorMessage ?? 'Signup failed. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (!mounted) return;
      final errorMsg = authProvider.errorMessage ?? 'Google Sign-In failed.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.getGradientColors();
    final accentColor = themeProvider.getAccentColor();
    final secondAccent = themeProvider.getSecondaryAccentColor();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondAccent.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: secondAccent.withValues(alpha: 0.06),
                    blurRadius: 80,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.08),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.04),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleIn(
                        delay: 0.0,
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [accentColor, secondAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.currency_exchange_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: themeProvider.getTextColor(),
                                letterSpacing: -0.75,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign up to manage exchange alerts',
                              style: TextStyle(
                                fontSize: 15,
                                color: themeProvider.getSecondaryTextColor(),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeInSlide(
                        delay: 0.1,
                        child: GlassCard(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                labelText: 'Full Name',
                                hintText: 'John Doe',
                                controller: _nameController,
                                prefixIcon: const Icon(Icons.person_outline_rounded),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: 'Email Address',
                                hintText: 'name@example.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.mail_outline_rounded),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: 'Password',
                                hintText: 'Create a strong password',
                                controller: _passwordController,
                                isPassword: true,
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: 'Confirm Password',
                                hintText: 'Repeat your password',
                                controller: _confirmPasswordController,
                                isPassword: true,
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      activeColor: accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _agreeToTerms = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'I agree to the Terms & Conditions',
                                      style: TextStyle(
                                        color: themeProvider.getSecondaryTextColor(),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Consumer<AuthProvider>(
                                builder: (context, auth, _) {
                                  return CustomButton(
                                    text: 'Get Started',
                                    isLoading: auth.isLoading,
                                    onPressed: _handleSignup,
                                    isFullWidth: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeInSlide(
                        delay: 0.2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Divider(color: themeProvider.getBorderColor().withValues(alpha: 0.5))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'or sign up with',
                                    style: TextStyle(
                                      color: themeProvider.getSecondaryTextColor().withValues(alpha: 0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: themeProvider.getBorderColor().withValues(alpha: 0.5))),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSocialButton(
                                    themeProvider,
                                    Icons.g_mobiledata,
                                    'Google',
                                    onTap: _handleGoogleLogin,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildSocialButton(
                                    themeProvider,
                                    Icons.facebook,
                                    'Facebook',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Facebook signup coming soon')),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: themeProvider.getSecondaryTextColor(),
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed('/login');
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(ThemeProvider themeProvider, IconData icon, String label, {required VoidCallback onTap}) {
    return ScaleButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: themeProvider.getBorderColor().withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
          color: themeProvider.getCardBackgroundColor().withValues(alpha: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: themeProvider.getTextColor(), size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: themeProvider.getTextColor(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
