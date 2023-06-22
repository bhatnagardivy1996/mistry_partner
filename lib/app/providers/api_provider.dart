import 'package:get/get.dart';

import '../../common/custom_trace.dart';
import '../services/auth_service.dart';
import '../services/global_service.dart';

mixin ApiClient {
  final globalService = Get.find<GlobalService>();
  final authService = Get.find<AuthService>();
  String baseUrl;

  String getBaseUrl(String path) {
    if (!path.endsWith('/')) {
      path += '/';
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (!baseUrl.endsWith('/')) {
      print("The url ends with / ${baseUrl + '/' + path}");
      return baseUrl + '/' + path;
    }
    return baseUrl + path;
  }

  String getApiBaseUrl(String path) {
    String _apiPath = "/admin/api/";
    if (path.startsWith('/')) {
      return _apiPath + path.substring(1);
    }
    return _apiPath + path;
  }

  Uri getApiBaseUri(String path) {
    return Uri.parse(getApiBaseUrl(path));
  }

  Uri getBaseUri(String path) {
    return Uri.parse(getBaseUrl(path));
  }

  void printUri(StackTrace stackTrace, Uri uri) {
    Get.log(CustomTrace(stackTrace, message: uri.toString()).toString());
  }
}
