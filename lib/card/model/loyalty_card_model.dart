class LoyaltyCardModel {
  final String id;
  final String businessId;
  final String cardType;
  final String cardDesc;
  final String companyName;
  final String rewardProgram;
  final int stampsCount;
  final String earnRuleType;
  final double earnValue;
  final int earnUnit;
  final String barcodeType;
  final String logo;
  final String logoFilePath;
  final String cardBackground;
  final String stampBackground;
  final String stampBackgroundPath;
  final String activeStamp;
  final String inactiveStamp;
  final String textColor;
  final String earnedRewardMessage;
  final bool isAddedToGoogleWallet;
  final bool isAddedToAppleWallet;
  final bool isAddedToWallet;

  LoyaltyCardModel({
    required this.id,
    required this.businessId,
    required this.cardType,
    required this.cardDesc,
    required this.companyName,
    required this.rewardProgram,
    required this.stampsCount,
    required this.earnRuleType,
    required this.earnValue,
    required this.earnUnit,
    required this.barcodeType,
    required this.logo,
    required this.logoFilePath,
    required this.cardBackground,
    required this.stampBackground,
    required this.stampBackgroundPath,
    required this.activeStamp,
    required this.inactiveStamp,
    required this.textColor,
    required this.earnedRewardMessage,
    required this.isAddedToGoogleWallet,
    required this.isAddedToAppleWallet,
    required this.isAddedToWallet,
  });

  factory LoyaltyCardModel.fromJson(Map json) {
    return LoyaltyCardModel(
      id: (json['id'] ?? '').toString(),
      businessId: (json['businessId'] ?? '').toString(),
      cardType: (json['cardType'] ?? '').toString(),
      cardDesc: (json['cardDesc'] ?? '').toString(),
      companyName: (json['companyName'] ?? '').toString(),
      rewardProgram: (json['rewardProgram'] ?? '').toString(),
      stampsCount: (json['stampsCount'] ?? 0) is int ? json['stampsCount'] : int.tryParse(json['stampsCount'].toString()) ?? 0,
      earnRuleType: (json['earnRuleType'] ?? '').toString(),
      earnValue: (json['earnValue'] ?? 0.0).toDouble(),
      earnUnit: (json['earnUnit'] ?? 0) is int ? json['earnUnit'] : int.tryParse(json['earnUnit'].toString()) ?? 0,
      barcodeType: (json['barcodeType'] ?? '').toString(),
      logo: (json['logo'] ?? '').toString(),
      logoFilePath: (json['logoFilePath'] ?? '').toString(),
      cardBackground: (json['cardBackground'] ?? '').toString(),
      stampBackground: (json['stampBackground'] ?? '').toString(),
      stampBackgroundPath: (json['stampBackgroundPath'] ?? '').toString(),
      activeStamp: (json['activeStamp'] ?? '').toString(),
      inactiveStamp: (json['inactiveStamp'] ?? '').toString(),
      textColor: (json['textColor'] ?? '').toString(),
      earnedRewardMessage: (json['earnedRewardMessage'] ?? '').toString(),
      isAddedToGoogleWallet: json['isAddedToGoogleWallet'] == true,
      isAddedToAppleWallet: json['isAddedToAppleWallet'] == true,
      isAddedToWallet: json['isAddedToWallet'] == true,
    );
  }
}

class BusinessGroupedCardsModel {
  final String businessId;
  final String businessName;
  final int points;
  final List<LoyaltyCardModel> cards;

  BusinessGroupedCardsModel({
    required this.businessId,
    required this.businessName,
    required this.points,
    required this.cards,
  });

  factory BusinessGroupedCardsModel.fromJson(Map json) {
    return BusinessGroupedCardsModel(
      businessId: (json['businessId'] ?? '').toString(),
      businessName: (json['businessName'] ?? '').toString(),
      points: (json['points'] ?? 0) is int ? json['points'] : int.tryParse(json['points'].toString()) ?? 0,
      cards: (json['cards'] is List)
          ? (json['cards'] as List).map((e) => LoyaltyCardModel.fromJson(e)).toList()
          : [],
    );
  }
}
