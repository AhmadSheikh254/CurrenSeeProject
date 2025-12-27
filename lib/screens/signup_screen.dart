import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/animations.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed. Please try again.')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();
        
        return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScaleIn(
                  delay: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join CurrenSee and start converting currencies',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.getSecondaryTextColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Full Name Field
                FadeInSlide(
                  delay: 0.1,
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(color: themeProvider.getTextColor()),
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                      prefixIcon: Icon(Icons.person, color: themeProvider.getSecondaryTextColor()),
                      filled: true,
                      fillColor: themeProvider.getCardBackgroundColor(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Email Field
                FadeInSlide(
                  delay: 0.2,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: themeProvider.getTextColor()),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                      prefixIcon: Icon(Icons.email, color: themeProvider.getSecondaryTextColor()),
                      filled: true,
                      fillColor: themeProvider.getCardBackgroundColor(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                FadeInSlide(
                  delay: 0.3,
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: themeProvider.getTextColor()),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                      prefixIcon: Icon(Icons.lock, color: themeProvider.getSecondaryTextColor()),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: themeProvider.getSecondaryTextColor(),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: themeProvider.getCardBackgroundColor(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password Field
                FadeInSlide(
                  delay: 0.4,
                  child: TextField(
                    controller: _confirmPasswordController,
                    style: TextStyle(color: themeProvider.getTextColor()),
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                      prefixIcon: Icon(Icons.lock_outline, color: themeProvider.getSecondaryTextColor()),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: themeProvider.getSecondaryTextColor(),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: themeProvider.getCardBackgroundColor(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Terms and Conditions Checkbox
                FadeInSlide(
                  delay: 0.5,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        fillColor: MaterialStateProperty.all(
                          _agreeToTerms ? themeProvider.getAccentColor() : themeProvider.getBorderColor(),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Terms and conditions coming soon')),
                            );
                          },
                          child: Text(
                            'I agree to Terms and Conditions',
                            style: TextStyle(
                              color: themeProvider.getSecondaryTextColor(),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Sign Up Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return FadeInSlide(
                      delay: 0.6,
                      child: SizedBox(
                        width: double.infinity,
                        child: ScaleButton(
                          onPressed: authProvider.isLoading ? null : _handleSignup,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: themeProvider.getAccentColor().withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: authProvider.isLoading
                                ? const CustomAnimatedLoader(size: 24)
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Divider
                FadeInSlide(
                  delay: 0.7,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: themeProvider.getBorderColor(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or',
                          style: TextStyle(color: themeProvider.getSecondaryTextColor()),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: themeProvider.getBorderColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Social Login Buttons
                FadeInSlide(
                  delay: 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        themeProvider, 
                        Icons.g_mobiledata, 
                        'Google',
                        onTap: _handleGoogleLogin,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        themeProvider, 
                        Icons.facebook, 
                        'Facebook',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Facebook login coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Sign In Link
                FadeInSlide(
                  delay: 0.7,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: themeProvider.getSecondaryTextColor()),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: themeProvider.getAccentColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }
  Widget _buildSocialButton(ThemeProvider themeProvider, IconData icon, String label, {required VoidCallback onTap}) {
    return ScaleButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: themeProvider.getBorderColor()),
          borderRadius: BorderRadius.circular(12),
          color: themeProvider.getCardBackgroundColor(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: themeProvider.getTextColor(), size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: themeProvider.getTextColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
