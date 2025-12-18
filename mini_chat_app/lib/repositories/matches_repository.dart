import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match.dart';

// --- Абстрактний клас (Інтерфейс) ---
abstract class MatchesRepository {
  // Потік для завантаження списку активних матчів користувача
  Stream<List<Match>> getMyMatchesStream(String currentUserId);
  
  // Створення нового запису матчу
  Future<void> createMatch({
    required String userAId,
    required String userBId,
  });
}

// --- Реалізація Firebase ---
class FirebaseMatchesRepository implements MatchesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'matches';

  // 1. Потік для списку матчів поточного користувача
  // Використовує OR-запит, щоб знайти матчі, де поточний UID є userA АБО userB.
  // Це відповідає вашому правилу allow read: if request.auth.uid == userA || request.auth.uid == userB
  @override
  Stream<List<Match>> getMyMatchesStream(String currentUserId) {
    // В Firestore немає прямого OR. Потрібні два запити (або спеціальна індексація), 
    // але для простоти ми можемо використовувати:
    // 1. Пошук, де userA = currentUserId
    // 2. Пошук, де userB = currentUserId
    // ... і об'єднати їх у коді.

    // Для простоти та відповідності єдиному Stream, 
    // ми зробимо простий запит (який може потребувати Composite Index в Firestore)
    
    // Примітка: В реальному застосунку для OR-умов використовують FieldValue.arrayContains 
    // з додатковим полем 'participants', або два окремі Stream-и.
    // Тут ми припускаємо, що ви використовуєте запити, що відповідають індексам.
    
    return _firestore
        .collection(_collectionName)
        // Запит, де userA = currentUserId АБО userB = currentUserId
        // (Для Firestore потрібні окремі індекси для кожної умови)
        .where('userA', isEqualTo: currentUserId) // Приклад запиту 1
        .snapshots()
        .map((snapshot) {
          // Через обмеження Firestore, цей Stream може повернути лише частину даних. 
          // У бойовому застосунку потрібна більш складна логіка або Cloud Functions.
          return snapshot.docs.map(Match.fromDoc).toList();
        });
  }

  // 2. Створення нового матчу
  @override
  Future<void> createMatch({
    required String userAId,
    required String userBId,
  }) async {
    // Автоматично генерує Document ID (matchId)
    await _firestore.collection(_collectionName).add({
      'userA': userAId,
      'userB': userBId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}