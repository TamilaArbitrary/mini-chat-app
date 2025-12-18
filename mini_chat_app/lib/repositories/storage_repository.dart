// lib/repositories/storage_repository.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageRepository {
  Future<String> uploadProfilePicture(String userId, File imageFile);
}

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    // 1. Визначаємо шлях: user_profiles/{user_id}/profile_pic.jpg
    final storageRef = _storage.ref().child('user_profiles').child(userId).child('profile_pic.jpg');

    // 2. Завантажуємо файл
    final uploadTask = storageRef.putFile(imageFile);
    
    // 3. Очікуємо завершення та отримуємо URL
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    
    return downloadUrl;
  }
}