import 'package:amin_pass/app/urls.dart';
import 'package:flutter/material.dart';

class RewardModel {
  final String id;
  final String rewardName;
  final String description;
  final int points;
  final String rewardType;
  final String image;
  final int expiryDays;
  final bool isClaimed;
  final String claimStatus;
  final String branchId;

  RewardModel({
    required this.id,
    required this.rewardName,
    required this.description,
    required this.points,
    required this.rewardType,
    required this.image,
    required this.expiryDays,
    required this.isClaimed,
    required this.claimStatus,
    required this.branchId,
  });

  factory RewardModel.fromJson(Map json) {
    try {
      // debugPrint('📄 RewardModel Parsing JSON: $json');
      String rawImage = (json['rewardImage'] ?? json['rewardImageFilePath'] ?? '').toString();
      String finalImage = rawImage;
      
      // If it's a relative path, prepend base URL (assuming base URL from ApiUrls)
      if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
        finalImage = "${ApiUrls.mediaBaseUrl}$rawImage";
      }

      return RewardModel(
        id: (json['id'] ?? '').toString(),
        rewardName: (json['rewardName'] ?? '').toString(),
        description: (json['reward'] ?? '').toString(),
        points: int.tryParse((json['rewardPoints'] ?? json['earnPoint'] ?? '0').toString()) ?? 0,
        rewardType: (json['rewardType'] ?? '').toString(),
        image: finalImage,
        expiryDays: int.tryParse((json['expiryDays'] ?? '0').toString()) ?? 0,
        isClaimed: json['isClaimed'] == true ||
            (json['isClaimed'] ?? '').toString().toLowerCase() == 'true' ||
            (json['claimStatus'] ?? '').toString().toUpperCase() == 'CLAIMED',
        claimStatus: (json['claimStatus'] ?? '').toString(),
        branchId: (json['branchId'] ?? '').toString(),
      );
    } catch (e) {
      debugPrint('❌ RewardModel.fromJson Error: $e');
      rethrow;
    }
  }
}
