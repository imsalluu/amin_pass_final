import 'package:get/get.dart';

class QrCodeController extends GetxController {
  final qrCode = ''.obs;
  final qrCodeUrl = ''.obs;

  /// login response থেকে call করবে
  void setQrData({
    required String code,
    required String url,
  }) {
    qrCode.value = code;
    qrCodeUrl.value = url;
  }
}
