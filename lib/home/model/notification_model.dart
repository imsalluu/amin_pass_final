class NotificationModel {
  final bool? success;
  final List<NotificationItem>? data;

  NotificationModel({this.success, this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => NotificationItem.fromJson(i)).toList()
          : null,
    );
  }
}

class NotificationItem {
  final String? id;
  final String? notificationId;
  final String? customerId;
  final bool? isRead;
  final bool? isDeleted;
  final DateTime? createdAt;
  final NotificationDetail? notification;

  NotificationItem({
    this.id,
    this.notificationId,
    this.customerId,
    this.isRead,
    this.isDeleted,
    this.createdAt,
    this.notification,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      notificationId: json['notificationId'],
      customerId: json['customerId'],
      isRead: json['isRead'],
      isDeleted: json['isDeleted'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null),
      notification: json['notification'] != null
          ? NotificationDetail.fromJson(json['notification'])
          : null,
    );
  }
}

class NotificationDetail {
  final String? id;
  final String? businessId;
  final String? branchId;
  final String? message;
  final String? sentByStaff;
  final DateTime? createdAt;

  NotificationDetail({
    this.id,
    this.businessId,
    this.branchId,
    this.message,
    this.sentByStaff,
    this.createdAt,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json['id'],
      businessId: json['businessId'],
      branchId: json['branchId'],
      message: json['message'],
      sentByStaff: json['sentByStaff'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null),
    );
  }
}
