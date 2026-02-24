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
  final RxList<BusinessGroupedCardsModel> myGroupedCards = <BusinessGroupedCardsModel>[].obs;
  final Rxn<LoyaltyCardModel> selectedCard = Rxn<LoyaltyCardModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLoyaltyCards();
    fetchMyAddedCards();
    
    // 🔹 Re-fetch cards whenever the active business ID changes
    ever(Get.find<ShopBranchController>().activeBusinessId, (_) {
      fetchLoyaltyCards();
    });
  }

  Future<void> fetchMyAddedCards() async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest(ApiUrls.getMyAddedCards);
      
      if (response.isSuccess == true && response.responseData != null) {
        final resData = response.responseData!;
        final data = resData['data'];
        if (data is List) {
          myGroupedCards.assignAll(data.map((e) => BusinessGroupedCardsModel.fromJson(e)).toList());
          debugPrint('✅ LoyaltyCardController: Fetched ${myGroupedCards.length} businesses with cards');
        }
      } else if (response.isSuccess == false) {
        debugPrint('❌ LoyaltyCardController fetchMyAddedCards Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController fetchMyAddedCards Exception: $e');
    } finally {
      isLoading.value = false;
    }
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
      
      if (response.isSuccess == true && response.responseData != null) {
        final resData = response.responseData!;
        final data = resData['data'];
        final List list = (data is List) ? data : [];
        
        cards.assignAll(list.map((e) => LoyaltyCardModel.fromJson(e)).toList());
        if (cards.isNotEmpty && selectedCard.value == null) {
          selectedCard.value = cards.first;
        }
        debugPrint('✅ LoyaltyCardController: Fetched ${cards.length} cards');
      } else if (response.isSuccess == false) {
        debugPrint('❌ LoyaltyCardController Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getGoogleWalletLink(String cardId) async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest("${ApiUrls.googleWalletLink}/$cardId");
      if (response.isSuccess == true) {
        final resData = response.responseData is Map ? response.responseData as Map : {};
        final data = (resData['data'] is Map) ? resData['data'] as Map : {};
        return data['link']?.toString();
      } else {
        debugPrint('❌ LoyaltyCardController getGoogleWalletLink Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController getGoogleWalletLink Exception: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAppleWalletLink(String cardId) async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest("${ApiUrls.appleWalletLink}/$cardId");
      if (response.isSuccess == true) {
        final resData = response.responseData is Map ? response.responseData as Map : {};
        final data = (resData['data'] is Map) ? resData['data'] as Map : {};
        
        final String? link = data['downloadLink']?.toString() ?? data['link']?.toString();
        final String? token = data['authenticationToken']?.toString();
        final String? serialNumber = data['serialNumber']?.toString();
        
        if (link != null) {
          return {
            'downloadLink': link,
            'authenticationToken': token,
            'serialNumber': serialNumber,
          };
        }
      } else {
        debugPrint('❌ LoyaltyCardController getAppleWalletLink Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController getAppleWalletLink Exception: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> registerAppleDevice({
    required String deviceId,
    required String passTypeId,
    required String serialNumber,
    required String authToken,
  }) async {
    try {
      isLoading.value = true;
      final String url = "${ApiUrls.appleRegistrationBase}/$deviceId/registrations/$passTypeId/$serialNumber";
      
      final headers = _client.commonHeaders();
      headers['Authorization'] = 'ApplePass $authToken';

      debugPrint('📤 Calling Register Device API: $url');
      final response = await _client.postRequest(
        url,
        body: {"pushToken": "any_random_string_for_testing"},
        customHeaders: headers,
      );
      
      if (response.isSuccess == true) {
        debugPrint('✅ Device registered successfully');
        return true;
      } else {
        debugPrint('❌ LoyaltyCardController registerAppleDevice Error: ${response.errorMassage}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController registerAppleDevice Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyWallets(String customerId) async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest("${ApiUrls.myWallets}/$customerId");
      if (response.isSuccess == true) {
        debugPrint('✅ LoyaltyCardController fetchMyWallets Success');
        // Handle response data if needed for UI
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController fetchMyWallets Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<dynamic, dynamic>?> getAppleWalletInfo(String serialNumber) async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest("${ApiUrls.appleWalletInfo}/$serialNumber");
      if (response.isSuccess == true) {
        final resData = response.responseData is Map ? response.responseData as Map : {};
        return (resData['data'] is Map) ? resData['data'] as Map : null;
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController getAppleWalletInfo Exception: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> saveCardToWallet(String cardId) async {
    try {
      isLoading.value = true;
      debugPrint('📤 Calling save-card API for card: $cardId');
      final response = await _client.postRequest(
        "${ApiUrls.saveCardToWallet}/$cardId",
        body: {},
      );
      
      if (response.isSuccess == true) {
        debugPrint('✅ Card saved to wallet successfully');
        return true;
      } else {
        debugPrint('❌ LoyaltyCardController saveCardToWallet Error: ${response.errorMassage}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ LoyaltyCardController saveCardToWallet Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
