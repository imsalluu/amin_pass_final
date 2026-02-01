import 'package:flutter/material.dart';

class TransactionModel {
  final String transactionId;
  final int earnedPoints;
  final String branchName;
  final String? cafeImage;
  final String date;
  final String branchId;

  TransactionModel({
    required this.transactionId,
    required this.earnedPoints,
    required this.branchName,
    this.cafeImage,
    required this.date,
    required this.branchId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      return TransactionModel(
        transactionId: (json['transactionId'] ?? '').toString(),
        earnedPoints: int.tryParse((json['earnedPoints'] ?? '0').toString()) ?? 0,
        branchName: (json['branchName'] ?? '').toString(),
        cafeImage: json['cafeImage'],
        date: (json['date'] ?? '').toString(),
        branchId: (json['branchId'] ?? '').toString(),
      );
    } catch (e) {
      debugPrint('❌ TransactionModel Parsing Error: $e');
      rethrow;
    }
  }
}
