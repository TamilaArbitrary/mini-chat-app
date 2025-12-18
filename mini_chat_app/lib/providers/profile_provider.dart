import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../repositories/profiles_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfilesRepository _repository; 
  Profile? _myProfile;
  bool _isLoading = false;

  ProfileProvider(this._repository);

  Profile? get myProfile => _myProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchMyProfile(String uid) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final profile = await _repository.getMyProfile(uid);
      _myProfile = profile;
    } catch (e) {
      _myProfile = null; 
      print("Profile not found for UID $uid. Requires setup.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // 2. Метод для оновлення профілю (викликається з EditProfileScreen/BLoC)
  Future<void> updateProfile(Profile profile) async {
      await _repository.updateProfile(profile);
      _myProfile = profile; // Оновлюємо локальну модель
      notifyListeners();
  }

  // 3. Метод для очищення (при логауті)
  void clearProfile() {
    _myProfile = null;
    notifyListeners();
  }
}