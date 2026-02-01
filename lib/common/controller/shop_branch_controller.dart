import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/app/token_service.dart';
import 'package:amin_pass/common/model/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/network/network_client.dart';

class ShopBranchController extends GetxController {
  final NetworkClient _client;
  ShopBranchController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<BranchModel> branches = <BranchModel>[].obs;

  /// 🌍 Active branch (global)
  final RxString activeBranchId = ''.obs;
  final RxString activeBusinessId = ''.obs;

  final GetStorage _storage = GetStorage();

  /// 🔄 Fetch All Branches
  Future<void> fetchAllBranches() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      debugPrint('🔍 ShopBranchController: Fetching branches...');

      final response = await _client.getRequest(ApiUrls.getAllRegisterBranch);
      debugPrint('📡 ShopBranchController: Response code: ${response.statusCode}, isSuccess: ${response.isSuccess}');

      if (response.isSuccess) {
        final List list = response.responseData?['data'] ?? [];
        branches.value = list.map((e) => BranchModel.fromJson(e)).toList();
        debugPrint('✅ ShopBranchController: Successfully fetched ${branches.length} branches');

        // 🔹 Sync activeBusinessId if we have an active branch but no business ID yet
        if (activeBranchId.value.isNotEmpty && activeBusinessId.value.isEmpty) {
          final branch = branches.firstWhereOrNull((b) => b.branchId == activeBranchId.value);
          if (branch != null && branch.businessId.isNotEmpty) {
            activeBusinessId.value = branch.businessId;
            await _storage.write('activeBusinessId', branch.businessId);
            debugPrint('✅ ShopBranchController: Synced Business ID from branches list: ${branch.businessId}');
          }
        }
      } else {
        errorMessage.value = response.errorMassage ?? 'Failed to load branches';
        debugPrint('❌ ShopBranchController: Fetch Branches Error - ${response.errorMassage}');
      }
    } catch (e, stack) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('❌ ShopBranchController Exception: $e');
      debugPrint('Stacktrace: $stack');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 Switch branch
  Future<void> switchBranch(String branchId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _client.postRequest(
        ApiUrls.switchBranch,
        body: {
          "branchId": branchId,
        },
      );

      /// ✅ IMPORTANT: NetworkResponse handle
      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        debugPrint('📡 ShopBranchController: switchBranch full response: $resData');
        
        // Try to get activeBranchId from data object or root
        final String? newBranchId = (resData?['data'] is Map)
            ? resData!['data']['activeBranchId']?.toString()
            : resData?['activeBranchId']?.toString() ?? resData?['data']?.toString();

        if (newBranchId != null && newBranchId.isNotEmpty) {
          debugPrint('✅ ShopBranchController: New Active Branch ID: $newBranchId');
          activeBranchId.value = newBranchId;
          await _storage.write('activeBranchId', newBranchId);

          // 🔹 Also try to find and set businessId
          final branch = branches.firstWhereOrNull((b) => b.branchId == newBranchId);
          if (branch != null && branch.businessId.isNotEmpty) {
             activeBusinessId.value = branch.businessId;
             await _storage.write('activeBusinessId', branch.businessId);
             debugPrint('✅ ShopBranchController: Found and saved Business ID: ${branch.businessId}');
          } else {
             // If not found in branches list (maybe it's a new login), try to extract from response if possible
             final String? respBusId = (resData?['data'] is Map) 
                ? resData!['data']['businessId']?.toString() 
                : resData?['businessId']?.toString();
             if (respBusId != null && respBusId.isNotEmpty) {
                activeBusinessId.value = respBusId;
                await _storage.write('activeBusinessId', respBusId);
                debugPrint('✅ ShopBranchController: Extracted Business ID from response: $respBusId');
             }
          }
        } else {
          debugPrint('⚠️ ShopBranchController: No branch ID found in response: $resData');
        }
      } else {
        errorMessage.value =
            response.errorMassage ?? 'Branch switch failed';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Load saved branch on app start
  void loadSavedBranch() {
    final savedBranch = _storage.read('activeBranchId');
    if (savedBranch != null && savedBranch.toString().isNotEmpty) {
      activeBranchId.value = savedBranch.toString();
    }

    final savedBusiness = _storage.read('activeBusinessId');
    if (savedBusiness != null && savedBusiness.toString().isNotEmpty) {
      activeBusinessId.value = savedBusiness.toString();
    }
  }

  @override
  void onInit() {
    loadSavedBranch();
    fetchAllBranches(); // ✅ Fetch branches on init
    super.onInit();
  }
}
