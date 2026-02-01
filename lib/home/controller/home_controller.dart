import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/home/model/home_activity_model.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkClient _client = Get.find<NetworkClient>();
  
  final isLoading = false.obs;
  final Rxn<ActivitySummary> summary = Rxn<ActivitySummary>();
  final RxList<ActivityItemModel> activities = <ActivityItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeActivity();
    
    // 🔹 Re-fetch activity whenever the branch changes
    ever(Get.find<ShopBranchController>().activeBranchId, (_) {
      fetchHomeActivity();
    });
  }

  Future<void> fetchHomeActivity() async {
    try {
      final activeBranchId = Get.find<ShopBranchController>().activeBranchId.value;
      if (activeBranchId.isEmpty) {
        debugPrint('⚠️ HomeController: No active branch ID. Skipping fetch activity.');
        return;
      }

      isLoading.value = true;
      final response = await _client.postRequest(ApiUrls.getCustomerActivity, body: {});
      
      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        if (resData != null) {
          final model = HomeActivityModel.fromJson(resData);
          summary.value = model.summary;
          activities.assignAll(model.activities);

          // 🔹 Sync reward points to ProfileController
          if (model.summary != null) {
            Get.find<ProfileController>().rewardPoints.value = model.summary!.totalAvailablePoints;
          }
          
          debugPrint('✅ HomeController: Fetched ${activities.length} activities');
        } else {
          debugPrint('⚠️ HomeController: Response data is not a Map: ${response.responseData}');
        }
      } else {
        debugPrint('❌ HomeController Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ HomeController Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
