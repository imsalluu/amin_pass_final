import 'package:amin_pass/app/urls.dart';
import 'package:flutter/material.dart';

class BranchModel {
  final String branchId;
  final String businessId;
  final String branchName;
  final String businessName;
  final String branchImageUrl;

  BranchModel({
    required this.branchId,
    required this.businessId,
    required this.branchName,
    required this.businessName,
    required this.branchImageUrl,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    try {
      final branchData = json['branch'] is Map ? json['branch'] as Map : {};
      final businessData = json['business'] is Map ? json['business'] as Map : {};

      return BranchModel(
        branchId: (json['branchId'] ?? branchData['id'] ?? '').toString(),
        businessId: (json['businessId'] ?? businessData['id'] ?? branchData['businessId'] ?? '').toString(),
        branchName: (branchData['name'] ?? businessData['name'] ?? 'Unknown Branch').toString(),
        businessName: (businessData['name'] ?? 'Unknown Business').toString(),
        branchImageUrl: () {
          String rawUrl = (branchData['branchImageUrl'] ?? json['branchImageUrl'] ?? '').toString();
          if (rawUrl.isNotEmpty && !rawUrl.startsWith('http')) {
            return "${ApiUrls.mediaBaseUrl}$rawUrl";
          }
          return rawUrl;
        }(),
      );
    } catch (e) {
      debugPrint('❌ BranchModel.fromJson Error: $e');
      return BranchModel(
        branchId: '',
        businessId: '',
        branchName: 'Error Loading',
        businessName: 'Error Loading',
        branchImageUrl: '',
      );
    }
  }
}
