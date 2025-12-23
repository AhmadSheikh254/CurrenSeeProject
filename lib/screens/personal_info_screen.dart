import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/animations.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        
        // Mix of different avatar styles using PNG format
        final avatarUrls = [
          'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
          'https://api.dicebear.com/7.x/avataaars/png?seed=Aneka',
          'https://api.dicebear.com/7.x/avataaars/png?seed=Luna',
          'https://api.dicebear.com/7.x/avataaars/png?seed=Max',
          'https://api.dicebear.com/7.x/bottts/png?seed=Robot1',
          'https://api.dicebear.com/7.x/bottts/png?seed=Robot2',
          'https://api.dicebear.com/7.x/adventurer/png?seed=Sarah',
          'https://api.dicebear.com/7.x/adventurer/png?seed=John',
          'https://api.dicebear.com/7.x/big-smile/png?seed=Happy',
          'https://api.dicebear.com/7.x/big-smile/png?seed=Joy',
          'https://api.dicebear.com/7.x/personas/png?seed=Alex',
          'https://api.dicebear.com/7.x/personas/png?seed=Sam',
        ];
        
        return AlertDialog(
          backgroundColor: themeProvider.getCardBackgroundColor(),
          title: Text(
            'Choose Avatar',
            style: TextStyle(
              color: themeProvider.getTextColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: avatarUrls.length,
              itemBuilder: (context, index) {
                final avatarUrl = avatarUrls[index];
                return GestureDetector(
                  onTap: () {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    authProvider.updatePhotoUrl(avatarUrl);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile picture updated!')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeProvider.getAccentColor(),
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 40);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: themeProvider.getTextColor()),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUserInfo(
        _nameController.text, 
        _emailController.text,
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personal information updated successfully')),
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
                        const SizedBox(width: 8),
                        Text(
                          'Personal Info',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const Spacer(),
                        if (!_isEditing)
                          IconButton(
                            icon: Icon(Icons.edit, color: themeProvider.getAccentColor()),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture
                            ScaleIn(
                              delay: 0.0,
                              child: Center(
                                child: Stack(
                                  children: [
                                    Consumer<AuthProvider>(
                                      builder: (context, authProvider, child) {
                                        final photoUrl = authProvider.user?.photoUrl ?? 
                                                        'https://i.pravatar.cc/150?img=11';
                                        
                                        return Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: themeProvider.getAccentColor().withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: NetworkImage(photoUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: themeProvider.getAccentColor(),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Name Field
                            FadeInSlide(
                              delay: 0.1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _nameController,
                                    enabled: _isEditing,
                                    style: TextStyle(color: themeProvider.getTextColor()),
                                    decoration: InputDecoration(
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
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                      ),
                                      prefixIcon: Icon(Icons.person, color: themeProvider.getAccentColor()),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Email Field
                            FadeInSlide(
                              delay: 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email Address',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    enabled: _isEditing,
                                    style: TextStyle(color: themeProvider.getTextColor()),
                                    decoration: InputDecoration(
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
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                      ),
                                      prefixIcon: Icon(Icons.email, color: themeProvider.getAccentColor()),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Phone Field
                            FadeInSlide(
                              delay: 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _phoneController,
                                    enabled: _isEditing,
                                    style: TextStyle(color: themeProvider.getTextColor()),
                                    decoration: InputDecoration(
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
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                      ),
                                      prefixIcon: Icon(Icons.phone, color: themeProvider.getAccentColor()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Save Button
                            if (_isEditing)
                              FadeInSlide(
                                delay: 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ScaleButton(
                                        onPressed: () {
                                          setState(() {
                                            _isEditing = false;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          decoration: BoxDecoration(
                                            color: themeProvider.getCardBackgroundColor(),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: themeProvider.getBorderColor()),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: themeProvider.getTextColor(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ScaleButton(
                                        onPressed: _saveChanges,
                                        child: Container(
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
                                          child: const Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 24),
                          ],
                        ),
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
}
