import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _bioController = TextEditingController(text: 'Passionate about faith and community.');
  final _churchController = TextEditingController(text: 'Lifechangers Church');
  final _locationController = TextEditingController(text: 'New York, NY');

  String _selectedGender = 'Male';
  String _selectedAgeRange = '25-34';
  String _selectedMaritalStatus = 'Single';
  String _selectedOccupation = 'Software Engineer';
  String _selectedInterests = 'Faith, Technology, Community';
  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55-64', '65+'];
  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed', 'Prefer not to say'];
  final List<String> _occupations = [
    'Software Engineer',
    'Teacher',
    'Healthcare Worker',
    'Business Owner',
    'Student',
    'Retired',
    'Other'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _churchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              _buildProfilePhotoSection(),
              
              const SizedBox(height: 24),
              
              // Personal Information
              _buildSection(
                'Personal Information',
                [
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    icon: Icons.person,
                    validator: (value) => value?.isEmpty == true ? 'First name is required' : null,
                  ),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    validator: (value) => value?.isEmpty == true ? 'Last name is required' : null,
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty == true) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Demographics
              _buildSection(
                'Demographics',
                [
                  _buildDropdownField(
                    label: 'Gender',
                    value: _selectedGender,
                    items: _genders,
                    onChanged: (value) => setState(() => _selectedGender = value!),
                  ),
                  _buildDropdownField(
                    label: 'Age Range',
                    value: _selectedAgeRange,
                    items: _ageRanges,
                    onChanged: (value) => setState(() => _selectedAgeRange = value!),
                  ),
                  _buildDropdownField(
                    label: 'Marital Status',
                    value: _selectedMaritalStatus,
                    items: _maritalStatuses,
                    onChanged: (value) => setState(() => _selectedMaritalStatus = value!),
                  ),
                  _buildDropdownField(
                    label: 'Occupation',
                    value: _selectedOccupation,
                    items: _occupations,
                    onChanged: (value) => setState(() => _selectedOccupation = value!),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Church & Location
              _buildSection(
                'Church & Location',
                [
                  _buildTextField(
                    controller: _churchController,
                    label: 'Church Name',
                    icon: Icons.church,
                  ),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // About
              _buildSection(
                'About',
                [
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    icon: Icons.info,
                    maxLines: 3,
                    hintText: 'Tell us about yourself...',
                  ),
                  _buildTextField(
                    controller: TextEditingController(text: _selectedInterests),
                    label: 'Interests',
                    icon: Icons.favorite,
                    readOnly: true,
                    onTap: _selectInterests,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Privacy Settings
              _buildPrivacySettings(),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Profile Photo',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 60,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      onPressed: _changeProfilePhoto,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _changeProfilePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Change Photo'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: _removeProfilePhoto,
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Settings',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Public Profile'),
                  subtitle: const Text('Allow others to see your profile'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Show Email'),
                  subtitle: const Text('Display email in your profile'),
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Show Phone'),
                  subtitle: const Text('Display phone number in your profile'),
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Show Location'),
                  subtitle: const Text('Display location in your profile'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save Changes',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancelChanges,
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeProfilePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text('Are you sure you want to remove your profile photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile photo removed'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _selectInterests() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Interests'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Faith', 'Technology', 'Community', 'Music', 'Sports', 'Art', 'Travel', 'Reading'
            ].map((interest) => CheckboxListTile(
              title: Text(interest),
              value: _selectedInterests.contains(interest),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedInterests += ', $interest';
                  } else {
                    _selectedInterests = _selectedInterests.replaceAll(', $interest', '');
                  }
                });
              },
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera functionality coming soon'),
      ),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery functionality coming soon'),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
      });
    }
  }

  void _cancelChanges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text('Are you sure you want to discard your changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
