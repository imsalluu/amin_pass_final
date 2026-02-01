class ClaimRewardModel {
  final String id;
  final String rewardName;
  final int rewardPoints;
  final String rewardImage;
  final String rewardStatus;
  final String branchId;
  final bool isClaimed;
  final String claimStatus;
  final int expiryDays;

  ClaimRewardModel({
    required this.id,
    required this.rewardName,
    required this.rewardPoints,
    required this.rewardImage,
    required this.rewardStatus,
    required this.branchId,
    required this.isClaimed,
    required this.claimStatus,
    required this.expiryDays,
  });

  factory ClaimRewardModel.fromJson(Map<String, dynamic> json) {
    return ClaimRewardModel(
      id: json['id'],
      rewardName: json['rewardName'],
      rewardPoints: json['rewardPoints'],
      rewardImage: json['rewardImage'] ?? '', // ✅ FIX
      rewardStatus: json['rewardStatus'],
      branchId: json['branchId'],
      isClaimed: json['isClaimed'] ?? false,
      claimStatus: json['claimStatus'],
      expiryDays: json['expiryDays'],
    );
  }
}
