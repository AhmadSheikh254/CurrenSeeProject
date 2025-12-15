import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

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
    _phoneController = TextEditingController(text: '');
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
      authProvider.updateUserInfo(_nameController.text, _emailController.text);
      
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
                            Center(
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
                                          border: Border.all(
                                            color: themeProvider.getAccentColor(),
                                            width: 3,
                                          ),
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
                            const SizedBox(height: 32),
                            
                            // Name Field
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
                                prefixIcon: Icon(Icons.person, color: themeProvider.getAccentColor()),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Email Field
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
                            const SizedBox(height: 24),
                            
                            // Phone Field
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
                            const SizedBox(height: 32),
                            
                            // Save Button
                            if (_isEditing)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeProvider.getCardBackgroundColor(),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(color: themeProvider.getBorderColor()),
                                        ),
                                      ),
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _saveChanges,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeProvider.getAccentColor(),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
