import 'package:amin_pass/profile/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController _controller =
  Get.find<EditProfileController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _controller.fetchProfile();

    _nameController.text = _controller.name.value;
    _emailController.text = _controller.email.value;
    _numberController.text = _controller.phone.value;
    _addressController.text = _controller.address.value;
  }

  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final mainContent = Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            /// PROFILE IMAGE
            Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : const Color(0xFFF5F5F5),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _selectedImage != null
                        ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                        : (_controller.avatarUrl.value.isNotEmpty
                        ? Image.network(
                      _controller.avatarUrl.value,
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.person,
                      size: 40,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey,
                    )),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7AA3CC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildProfileField(
              "Name",
              _nameController,
              isDark: isDark,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: 16),

            _buildProfileField(
              "Email Address",
              _emailController,
              isDark: isDark,
              isDesktop: isDesktop,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            _buildProfileField(
              "Number",
              _numberController,
              isDark: isDark,
              isDesktop: isDesktop,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildProfileField(
              "Address",
              _addressController,
              isDark: isDark,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: 32),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success =
                  await _controller.updateProfile(
                    name: _nameController.text.trim(),
                    phone: _numberController.text.trim(),
                    address: _addressController.text.trim(),
                    avatar: _selectedImage,
                  );

                  if (success) {
                    Get.snackbar(
                        'Success', 'Profile updated successfully');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA3CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });

    /// DESKTOP
    if (isDesktop) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SizedBox(width: 600, child: mainContent),
        ),
      );
    }

    /// MOBILE
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: mainContent,
    );
  }

  Widget _buildProfileField(
      String label,
      TextEditingController controller, {
        required bool isDark,
        bool isDesktop = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    final fieldHeight = isDesktop ? 40.0 : 50.0;
    final fontSize = isDesktop ? 13.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: fontSize,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.black12 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
