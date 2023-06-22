import 'package:get/get.dart';

import '../models/e_provider_type_model.dart';
import '../models/provider_registration.dart';
import '../models/register_places.dart';
import '../models/register_state.dart';
import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> login(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<User> verifyPhone(String smsCode) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.verifyPhone(smsCode);
  }

  Future<User> verifyOTP(String smsCode, String mobileno) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.verifyOTP(smsCode, mobileno);
  }

  Future<dynamic> sendCodeToPhone() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getMobilelogin();
  }

  Future<void> generateOTP(String mobileno) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getMobileOTP(mobileno);
  }

  Future registerProvider(RegProvider regProvider) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.registerProvider(regProvider);
  }

  Future<List<CatService>> getServiceCategories() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getServiceCategories();
  }

  Future<List<CatService>> getServices(String id) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getService(id);
  }

  Future<List<EProviderType>> getProvidertype() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getProvidertype();
  }

  Future<List<States>> getStateslist() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getState();
  }

  Future<List<Places>> getCities(String id) async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getCities(id);
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
