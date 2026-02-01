import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/profile/model/transaction_model.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryController extends GetxController {
  final NetworkClient _client;
  TransactionHistoryController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTransactionHistory();

    // Re-fetch transactions whenever the active branch changes
    ever(Get.find<ShopBranchController>().activeBranchId, (String branchId) {
      if (branchId.isNotEmpty) {
        debugPrint('🔄 TransactionHistoryController: activeBranchId changed to "$branchId". Refreshing transactions...');
        getTransactionHistory();
      }
    });
  }

  Future<void> getTransactionHistory() async {
    try {
      final activeBranchId = Get.find<ShopBranchController>().activeBranchId.value;
      debugPrint('🔍 TransactionHistoryController: Fetching transactions for branch: "$activeBranchId"');

      if (activeBranchId.isEmpty) {
        debugPrint('⚠️ TransactionHistoryController: No active branch ID. Skipping fetch.');
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Pass branchId as query parameter if supported/needed
      final response = await _client.getRequest("${ApiUrls.getTransactionHistory}?branchId=$activeBranchId");
      debugPrint('📡 TransactionHistoryController: Response: ${response.statusCode}, isSuccess: ${response.isSuccess}');

      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        
        List list = [];
        if (resData?['data'] is List) {
          list = resData!['data'];
        } else if (response.responseData is List) {
          list = response.responseData as List;
        }

        debugPrint('📦 TransactionHistoryController: Data list size: ${list.length}');

        final List<TransactionModel> parsedList = [];
        for (var e in list) {
          try {
            parsedList.add(TransactionModel.fromJson(e));
          } catch (err) {
            debugPrint('❌ Error parsing Transaction: $err');
          }
        }

        // If API returns filtered data (likely), we just use it.
        // If the model had branchId, we could double check, but since it might be missing,
        // we trust the API + query param.
        transactions.value = parsedList;

        debugPrint('✅ TransactionHistoryController: Filtered transactions: ${transactions.length}');
      } else {
        errorMessage.value = response.errorMassage ?? 'Failed to load transaction history';
        debugPrint('❌ TransactionHistoryController: Error - ${response.errorMassage}');
      }
    } catch (e, stack) {
      errorMessage.value = e.toString();
      debugPrint('❌ TransactionHistoryController Exception: $e');
      debugPrint('Stacktrace: $stack');
    } finally {
      isLoading.value = false;
    }
  }
}
