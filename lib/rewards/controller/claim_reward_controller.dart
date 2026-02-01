import 'package:get/get.dart';
import '../../core/services/network/network_client.dart';
import '../../app/token_service.dart';
import '../../app/urls.dart';
import '../model/claim_reward_model.dart';

class ClaimRewardController extends GetxController {
  final NetworkClient _client;
  ClaimRewardController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ClaimRewardModel> rewards = <ClaimRewardModel>[].obs;


  Future<void> fetchClaimRewards() async {
    final branchId = TokenService.activeBranchId;
    if (branchId == null) {
      rewards.clear();
      return;
    }

    isLoading.value = true;

    final response = await _client.getRequest(ApiUrls.getClaimRewards);

    isLoading.value = false;

    if (!response.isSuccess) return;

    final List list = response.responseData?['data'] ?? [];

    rewards.value = list
        .map((e) => ClaimRewardModel.fromJson(e))
        .where((e) => e.branchId == branchId && e.rewardStatus == 'ACTIVE')
        .toList();
  }
}
