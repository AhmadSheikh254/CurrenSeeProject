import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials.')),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInSlide(
                  delay: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your CurrenSee account',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.getSecondaryTextColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Email Field
                FadeInSlide(
                  delay: 0.1,
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
                // Password Field
                FadeInSlide(
                  delay: 0.2,
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: themeProvider.getTextColor()),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
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
                const SizedBox(height: 16),
                // Forgot Password
                FadeInSlide(
                  delay: 0.3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset coming soon')),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: themeProvider.getSecondaryTextColor()),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return FadeInSlide(
                      delay: 0.4,
                      child: SizedBox(
                        width: double.infinity,
                        child: ScaleButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
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
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
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
                const SizedBox(height: 16),
                // Guest Mode Button
                FadeInSlide(
                  delay: 0.5,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
                        historyProvider.updateUserId(null);
                        Navigator.of(context).pushReplacementNamed('/home_guest');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: themeProvider.getBorderColor(), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: themeProvider.getCardBackgroundColor(),
                      ),
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                FadeInSlide(
                  delay: 0.6,
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
                  delay: 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(themeProvider, Icons.g_mobiledata, 'Google'),
                      const SizedBox(width: 16),
                      _buildSocialButton(themeProvider, Icons.facebook, 'Facebook'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Sign Up Link
                FadeInSlide(
                  delay: 0.8,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: themeProvider.getSecondaryTextColor()),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/signup');
                          },
                          child: Text(
                            'Sign Up',
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

  Widget _buildSocialButton(ThemeProvider themeProvider, IconData icon, String label) {
    return ScaleButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label login coming soon')),
        );
      },
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
