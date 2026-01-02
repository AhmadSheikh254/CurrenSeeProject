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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Expanded list of aesthetic DiceBear styles
    final avatarStyles = [
      'lorelei',
      'notionists',
      'micah',
      'adventurer',
      'open-peeps',
      'bottts',
      'pixel-art',
      'miniavs',
      'big-smile',
      'croodles',
      'shapes',
      'icons',
    ];

    // Special Character Avatars
    final specialCharacters = [
      {'name': 'Eleven', 'url': 'https://img.icons8.com/color/512/eleven.png'},
      {'name': 'Dustin', 'url': 'https://img.icons8.com/color/512/dustin-henderson.png'},
      {'name': 'Mike', 'url': 'https://img.icons8.com/color/512/mike-wheeler.png'},
      {'name': 'Steve', 'url': 'https://img.icons8.com/color/512/steve-harrington.png'},
      {'name': 'Vecna', 'url': 'https://img.icons8.com/color/512/vecna.png'},
      {'name': 'Goku', 'url': 'https://img.icons8.com/color/512/goku.png'},
      {'name': 'Vegeta', 'url': 'https://img.icons8.com/color/512/vegeta.png'},
      {'name': 'Doraemon', 'url': 'https://img.icons8.com/color/512/doraemon.png'},
      {'name': 'Shin-chan', 'url': 'https://img.icons8.com/color/512/shin-chan.png'},
    ];

    List<String> generateUrls() {
      final List<String> urls = [];
      final random = DateTime.now().millisecondsSinceEpoch;
      for (var style in avatarStyles) {
        // Generate 1 variation for each style to keep it diverse but not overwhelming
        urls.add('https://api.dicebear.com/7.x/$style/png?seed=${random}_$style');
      }
      urls.shuffle();
      return urls;
    }

    List<String> currentUrls = generateUrls();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: themeProvider.getSecondaryTextColor().withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose Avatar',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.getTextColor(),
                                  ),
                                ),
                                Text(
                                  'Select a style that fits you',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeProvider.getSecondaryTextColor(),
                                  ),
                                ),
                              ],
                            ),
                            ScaleButton(
                              onPressed: () {
                                setModalState(() {
                                  currentUrls = generateUrls();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: themeProvider.getAccentColor().withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: themeProvider.getAccentColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Divider(),
                      
                      // Grid
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(24),
                          children: [
                            // Special Characters Section
                            Text(
                              'Special Characters',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getAccentColor(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                              itemCount: specialCharacters.length,
                              itemBuilder: (context, index) {
                                final char = specialCharacters[index];
                                return _buildAvatarItem(char['url']!, char['name']!, themeProvider, authProvider);
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Aesthetic Styles Section
                            Text(
                              'Aesthetic Styles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getAccentColor(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1,
                              ),
                              itemCount: currentUrls.length,
                              itemBuilder: (context, index) {
                                final url = currentUrls[index];
                                return _buildAvatarItem(url, 'Style ${index + 1}', themeProvider, authProvider);
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Cancel Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: ScaleButton(
                          onPressed: () => Navigator.pop(context),
                          child: Container(
                            width: double.infinity,
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
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarItem(String url, String name, ThemeProvider themeProvider, AuthProvider authProvider) {
    return FadeInSlide(
      duration: 0.4,
      beginOffset: const Offset(0, 0.1),
      child: ScaleButton(
        onPressed: () {
          authProvider.updatePhotoUrl(url);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name selected!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: themeProvider.getAccentColor(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeProvider.isDarkMode 
                ? Colors.white.withOpacity(0.05) 
                : Colors.grey.withOpacity(0.1),
            border: Border.all(
              color: themeProvider.getBorderColor(),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(themeProvider.getAccentColor()),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person_rounded,
                  color: themeProvider.getSecondaryTextColor(),
                  size: 30,
                );
              },
            ),
          ),
        ),
      ),
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
                                                        'https://api.dicebear.com/7.x/lorelei/png?seed=CurrenSee';
                                        
                                        return Hero(
                                          tag: 'profile_avatar',
                                          child: Container(
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
