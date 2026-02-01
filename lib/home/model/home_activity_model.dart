class HomeActivityModel {
  final ActivitySummary? summary;
  final List<ActivityItemModel> activities;

  HomeActivityModel({
    this.summary,
    required this.activities,
  });

  factory HomeActivityModel.fromJson(Map json) {
    // 🔹 Robust 'data' extraction with fallback to root
    final Map dataMap = (json['data'] is Map) 
        ? json['data'] 
        : (json['summary'] != null || json['activities'] != null) ? json : {};
    
    final List listData = (dataMap['activities'] is List) ? dataMap['activities'] : [];
    
    return HomeActivityModel(
      summary: (dataMap['summary'] is Map) ? ActivitySummary.fromJson(dataMap['summary']) : null,
      activities: listData.map((e) => ActivityItemModel.fromJson(e)).toList(),
    );
  }
}

class ActivitySummary {
  final String branchId;
  final String branchName;
  final int totalAvailablePoints;
  final int claimableRewardsCount;
  final double progressPercentage;
  final bool canClaim;
  final int pointsNeeded;
  final String statusMessage;
  final String? nextReward;

  ActivitySummary({
    required this.branchId,
    required this.branchName,
    required this.totalAvailablePoints,
    required this.claimableRewardsCount,
    required this.progressPercentage,
    required this.canClaim,
    required this.pointsNeeded,
    required this.statusMessage,
    this.nextReward,
  });

  factory ActivitySummary.fromJson(Map json) {
    return ActivitySummary(
      branchId: (json['branchId'] ?? '').toString(),
      branchName: (json['branchName'] ?? '').toString(),
      totalAvailablePoints: (json['totalAvailablePoints'] ?? 0) is int ? json['totalAvailablePoints'] : int.tryParse(json['totalAvailablePoints'].toString()) ?? 0,
      claimableRewardsCount: (json['claimableRewardsCount'] ?? 0) is int ? json['claimableRewardsCount'] : int.tryParse(json['claimableRewardsCount'].toString()) ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      canClaim: json['canClaim'] ?? false,
      pointsNeeded: (json['pointsNeeded'] ?? 0) is int ? json['pointsNeeded'] : int.tryParse(json['pointsNeeded'].toString()) ?? 0,
      statusMessage: (json['statusMessage'] ?? '').toString(),
      nextReward: json['nextReward']?.toString(),
    );
  }
}

class ActivityItemModel {
  final String id;
  final String type;
  final String activityName;
  final String rewardName;
  final String branchName;
  final String date;

  ActivityItemModel({
    required this.id,
    required this.type,
    required this.activityName,
    required this.rewardName,
    required this.branchName,
    required this.date,
  });

  factory ActivityItemModel.fromJson(Map json) {
    String rawDate = (json['date'] ?? '').toString();
    String formattedDate = rawDate;
    
    try {
      if (rawDate.isNotEmpty) {
        DateTime dt = DateTime.parse(rawDate).toLocal();
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        formattedDate = "${dt.day} ${months[dt.month - 1]} ${dt.year}";
      }
    } catch (_) {}

    return ActivityItemModel(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      activityName: (json['activityName'] ?? '').toString(),
      rewardName: (json['rewardName'] ?? '').toString(),
      branchName: (json['branchName'] ?? '').toString(),
      date: formattedDate,
    );
  }
}
