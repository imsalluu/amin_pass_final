import 'dart:io';
import 'package:get/get.dart';
import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController {
  final NetworkClient _client = Get.find<NetworkClient>();
  final isLoading = false.obs;

  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;
  final avatarUrl = ''.obs;

  /// ✅ GET PROFILE
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await _client.getRequest(ApiUrls.myProfile);

      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;

        Map? data;
        if (resData != null) {
          if (resData['data'] is Map) {
            data = resData['data'] as Map;
          } else if (resData['user'] is Map) {
            data = resData['user'] as Map;
          } else {
            data = resData;
          }
        }

        if (data != null) {
          name.value = (data['name'] ?? data['fullName'] ?? '').toString();
          email.value = (data['email'] ?? '').toString();
          phone.value = (data['phone'] ?? '').toString();
          address.value = (data['address'] ?? '').toString();
          
          String rawAvatar = (data['avatarUrl'] ?? data['avatar'] ?? '').toString();
          if (rawAvatar.isNotEmpty && !rawAvatar.startsWith('http')) {
            avatarUrl.value = "${ApiUrls.mediaBaseUrl}$rawAvatar";
          } else {
            avatarUrl.value = rawAvatar;
          }
        }
      } else {
        Get.snackbar('Error', response.errorMassage ?? 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ UPDATE PROFILE
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    try {
      isLoading.value = true;
      debugPrint('📝 EditProfileController: Updating profile...');

      final response = await _client.patchMultipartRequest(
        ApiUrls.updateProfile,
        fields: {
          'name': name,
          'phone': phone,
          'address': address,
        },
        files: avatar != null ? {'avatar': avatar.path} : null,
      );

      if (response.isSuccess == true) {
        await fetchProfile(); // refresh local data
        return true;
      } else {
        Get.snackbar('Error', response.errorMassage ?? 'Profile update failed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ EditProfileController Update Error: $e');
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
