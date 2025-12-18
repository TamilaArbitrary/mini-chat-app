import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile.dart';

abstract class ProfilesRepository {
  Stream<List<Profile>> getProfilesStream(); 
  
  Future<void> updateProfile(Profile profile);
  Future<Profile> getMyProfile(String uid);
}

class FirebaseProfilesRepository implements ProfilesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Потік для списку профілів (MatchesScreen)
  @override
  Stream<List<Profile>> getProfilesStream() {
    // Тут можна додати фільтри для дистанції, гендеру, тощо
    return _firestore.collection('users')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map(Profile.fromDoc).toList();
      });
  }

  // 2. Оновлення профілю (для пункту 5)
  @override
  Future<void> updateProfile(Profile profile) async {
    // Встановлення Document ID = UID користувача
    await _firestore.collection('users').doc(profile.id).set(
      profile.toMap(),
      SetOptions(merge: true), // Використовуємо merge, щоб не перезаписати весь документ
    );
  }
  
  // 3. Отримання власного профілю
  @override
  Future<Profile> getMyProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
        throw Exception("Profile not found");
    }
    return Profile.fromDoc(doc);
  }
}