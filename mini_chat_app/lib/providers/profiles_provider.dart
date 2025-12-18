import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../repositories/profiles_repository.dart';

class ProfilesProvider extends ChangeNotifier {
  final ProfilesRepository _repository;

  List<Profile> _allProfiles = [];
  List<Profile> _filteredProfiles = [];

  String? _currentUserId;
  Map<String, dynamic> _activeFilters = {};

  ProfilesProvider(this._repository);

  List<Profile> get allProfiles => _allProfiles;
  List<Profile> get filteredProfiles => _filteredProfiles;
  Map<String, dynamic> get activeFilters => _activeFilters;

  void initialize(String userId) {
    if (_currentUserId == userId) return; // Уникаємо повторної ініціалізації
    
    _currentUserId = userId; 
    if (_allProfiles.isNotEmpty) {
        _applyFilters();
        notifyListeners();
    }
    _listenToProfilesStream(); // Запускаємо слухання
  }

  void _listenToProfilesStream() {
    _repository.getProfilesStream().listen((profiles) {
      _allProfiles = profiles;
      _applyFilters();
      notifyListeners();
    });
  }

  void setFilters(Map<String, dynamic> filters) {
    _activeFilters = filters;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _activeFilters = {};
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_currentUserId == null) {
        _filteredProfiles = [];
        return;
    }
   Iterable<Profile> tempProfiles = _allProfiles.where((p) => p.id != _currentUserId);

    tempProfiles = tempProfiles.where((p) {
      // Ґендер
      if (_activeFilters.containsKey("gender") &&
          _activeFilters["gender"] != "all") {
        if (p.gender != _activeFilters["gender"]) return false;
      }

      // Мін/макс вік
      if (_activeFilters.containsKey("age_min") &&
          p.age < _activeFilters["age_min"]) {
        return false;
      }
      if (_activeFilters.containsKey("age_max") &&
          p.age > _activeFilters["age_max"]) {
        return false;
      }

      // Дистанція
      if (_activeFilters.containsKey("distance") &&
          p.distance > _activeFilters["distance"]) {
        return false;
      }
      
      return true;
    });
    _filteredProfiles = tempProfiles.toList();
  }
}
