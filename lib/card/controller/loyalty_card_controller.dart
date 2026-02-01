import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/card/model/loyalty_card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoyaltyCardController extends GetxController {
  final NetworkClient _client = Get.find<NetworkClient>();
  
  final isLoading = false.obs;
  final RxList<LoyaltyCardModel> cards = <LoyaltyCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoyaltyCards();
    
    // 🔹 Re-fetch cards whenever the active business ID changes
    ever(Get.find<ShopBranchController>().activeBusinessId, (_) {
      fetchLoyaltyCards();
    });
  }

  Future<void> fetchLoyaltyCards() async {
    try {
      final activeBusinessId = Get.find<ShopBranchController>().activeBusinessId.value;
      if (activeBusinessId.isEmpty) {
         debugPrint('⚠️ LoyaltyCardController: No active business ID. Skipping fetch.');
         return;
      }

      isLoading.value = true;
      
      final response = await _client.getRequest("${ApiUrls.getCardsByBusiness}/$activeBusinessId");
      
      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        final List list = (resData?['data'] is List) ? resData!['data'] : (response.responseData is List) ? response.responseData as List : [];
        
        cards.assignAll(list.map((e) => LoyaltyCardModel.fromJson(e)).toList());
        debugPrint('✅ LoyaltyCardController: Fetched ${cards.length} cards');
      } else {
        debugPrint('❌ LoyaltyCardController Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
