import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/rewards/model/earn_reward_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/network/network_client.dart';

class EarnRewardController extends GetxController {
  final NetworkClient _client;
  EarnRewardController(this._client);

  /// loaders
  final RxBool isLoadingEarn = false.obs;
  final RxBool isLoadingClaim = false.obs;

  final RxString errorMessage = ''.obs;

  /// data lists
  final RxList<RewardModel> earnRewards = <RewardModel>[].obs;
  final RxList<RewardModel> claimRewards = <RewardModel>[].obs;

  /// 🔹 Get Earn Rewards
  Future<void> getEarnRewards() async {
    try {
      final activeBranchId = Get.find<ShopBranchController>().activeBranchId.value;
      debugPrint('🔍 EarnRewardController: Current activeBranchId: "$activeBranchId"');
      
      if (activeBranchId.isEmpty) {
        debugPrint('⚠️ EarnRewardController: No active branch ID. Skipping fetch.');
        return;
      }

      isLoadingEarn.value = true;
      errorMessage.value = '';

      final response = await _client.getRequest(ApiUrls.getMyEarnRewards);
      debugPrint('📡 EarnRewardController: getEarnRewards response: ${response.statusCode}, isSuccess: ${response.isSuccess}');

      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        
        // 🔹 Try 'data', then 'rewards', then root if it is a list
        List list = [];
        if (resData?['data'] is List) {
          list = resData!['data'];
        } else if (resData?['rewards'] is List) {
          list = resData!['rewards'];
        } else if (response.responseData is List) {
          list = response.responseData as List;
        }
        
        debugPrint('📦 EarnRewardController: Data list size: ${list.length}');
        
        final List<RewardModel> parsedList = [];
        for (var e in list) {
          try {
            parsedList.add(RewardModel.fromJson(e));
          } catch (err) {
            debugPrint('❌ Error parsing Earn Reward: $err');
          }
        }

        debugPrint('📦 EarnRewardController: Total parsed rewards: ${parsedList.length}');

        earnRewards.value = parsedList
            .where((e) {
              final match = e.branchId.trim().toLowerCase() == activeBranchId.trim().toLowerCase();
              return match;
            })
            .toList();
            
        debugPrint('✅ EarnRewardController: Filtered earn rewards: ${earnRewards.length}');
      } else {
        errorMessage.value = response.errorMassage ?? 'Failed to load earn rewards';
        debugPrint('❌ EarnRewardController: Error - ${response.errorMassage}');
      }
    } catch (e, stack) {
      errorMessage.value = e.toString();
      debugPrint('❌ EarnRewardController Exception: $e');
      debugPrint('Stacktrace: $stack');
    } finally {
      isLoadingEarn.value = false;
    }
  }


  final RxInt branchPoints = 0.obs;

  /// 🔹 Get Claim Rewards
  Future<void> getClaimRewards() async {
    try {
      final activeBranchId = Get.find<ShopBranchController>().activeBranchId.value;
      debugPrint('🔍 EarnRewardController: Fetching rewards for branch: "$activeBranchId"');

      if (activeBranchId.isEmpty) {
        debugPrint('⚠️ EarnRewardController: No active branch ID. Skipping fetch.');
        return;
      }

      isLoadingClaim.value = true;
      errorMessage.value = '';

      // Also fetch branch summary for points
      await fetchBranchSummary();

      final response = await _client.getRequest(ApiUrls.getAllRewards);
      debugPrint('📡 EarnRewardController: getClaimRewards response: ${response.statusCode}, isSuccess: ${response.isSuccess}');

      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        
        // 🔹 Try 'data', then 'rewards', then root if it is a list
        List list = [];
        if (resData?['data'] is List) {
          list = resData!['data'];
        } else if (resData?['rewards'] is List) {
          list = resData!['rewards'];
        } else if (response.responseData is List) {
          list = response.responseData as List;
        }

        debugPrint('📦 EarnRewardController: Data list size: ${list.length}');
        
        if (list.isEmpty && resData != null) {
          debugPrint('⚠️ EarnRewardController: No rewards found in "data" or "rewards". Response: $resData');
        }

        final List<RewardModel> parsedList = [];
        for (var e in list) {
          try {
            parsedList.add(RewardModel.fromJson(e));
          } catch (err) {
            debugPrint('❌ Error parsing Claim Reward: $err');
          }
        }

        debugPrint('📦 EarnRewardController: Total parsed rewards: ${parsedList.length}');

        claimRewards.value = parsedList
            .where((e) {
              final match = e.branchId.trim().toLowerCase() == activeBranchId.trim().toLowerCase();
              return match;
            })
            .toList();

        debugPrint('✅ EarnRewardController: Filtered claim rewards: ${claimRewards.length}');
      } else {
        errorMessage.value = response.errorMassage ?? 'Failed to load claim rewards';
        debugPrint('❌ EarnRewardController: Error - ${response.errorMassage}');
      }
    } catch (e, stack) {
      errorMessage.value = e.toString();
      debugPrint('❌ EarnRewardController Exception: $e');
      debugPrint('Stacktrace: $stack');
    } finally {
      isLoadingClaim.value = false;
    }
  }

  /// 🔹 Fetch Branch Summary (for points)
  Future<void> fetchBranchSummary() async {
    try {
      final activeBranchId = Get.find<ShopBranchController>().activeBranchId.value;
      if (activeBranchId.isEmpty) return;

      final response = await _client.postRequest(
        ApiUrls.getCustomerActivity,
        body: {"branchId": activeBranchId},
      );

      if (response.isSuccess) {
        final data = response.responseData?['data'];
        final summary = data?['summary'];
        if (summary != null) {
          branchPoints.value = int.tryParse(summary['totalAvailablePoints']?.toString() ?? '0') ?? 0;
          debugPrint('✅ EarnRewardController: Branch Points updated: ${branchPoints.value}');
        }
      }
    } catch (e) {
      debugPrint('❌ EarnRewardController fetchBranchSummary Error: $e');
    }
  }

  /// 🔹 Claim Reward
  Future<void> claimReward(String rewardId) async {
    try {
      isLoadingClaim.value = true;
      debugPrint('🎁 EarnRewardController: Claiming reward: $rewardId');

      final response = await _client.postRequest("${ApiUrls.claimReward}/$rewardId", body: {});
      debugPrint('📡 EarnRewardController: claimReward response: ${response.statusCode}');

      if (response.isSuccess == true) {
        Get.snackbar(
          'Success',
          'Reward claimed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Refresh points and rewards list
        await Get.find<ProfileController>().fetchProfile();
        await fetchBranchSummary(); // Refresh branch specific points
        await getClaimRewards();
      } else {
        Get.snackbar(
          'Error',
          response.errorMassage ?? 'Failed to claim reward',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('❌ EarnRewardController Claim Exception: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingClaim.value = false;
    }
  }

  @override
  void onInit() {
    getEarnRewards();
    getClaimRewards();

    // 🔹 Re-fetch rewards whenever the active branch changes
    ever(Get.find<ShopBranchController>().activeBranchId, (String branchId) {
      if (branchId.isNotEmpty) {
        debugPrint('🔄 EarnRewardController: activeBranchId changed to "$branchId". Refreshing rewards...');
        getEarnRewards();
        getClaimRewards();
      }
    });

    super.onInit();
  }
}
