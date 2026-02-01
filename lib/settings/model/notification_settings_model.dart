class NotificationSettingsModel {
  final bool smsUpdates;
  final bool allowLocation;
  final bool pushNotification;
  final bool birthdayRewards;

  NotificationSettingsModel({
    required this.smsUpdates,
    required this.allowLocation,
    required this.pushNotification,
    required this.birthdayRewards,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      smsUpdates: json['smsUpdates'] ?? false,
      allowLocation: json['allowLocation'] ?? false,
      pushNotification: json['pushNotification'] ?? false,
      birthdayRewards: json['birthdayRewards'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "smsUpdates": smsUpdates,
      "allowLocation": allowLocation,
      "pushNotification": pushNotification,
      "birthdayRewards": birthdayRewards,
    };
  }

  NotificationSettingsModel copyWith({
    bool? smsUpdates,
    bool? allowLocation,
    bool? pushNotification,
    bool? birthdayRewards,
  }) {
    return NotificationSettingsModel(
      smsUpdates: smsUpdates ?? this.smsUpdates,
      allowLocation: allowLocation ?? this.allowLocation,
      pushNotification: pushNotification ?? this.pushNotification,
      birthdayRewards: birthdayRewards ?? this.birthdayRewards,
    );
  }
}
