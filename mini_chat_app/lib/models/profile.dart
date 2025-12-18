
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String email; 
  final double distance;
  final String imageUrl;

  const Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.distance,
    required this.imageUrl,
  });

  factory Profile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!; 

    return Profile(
      id: doc.id, 
      
      name: data['name'] as String,
      age: data['age'] as int,
      gender: data['gender'] as String,
      email: data['email'] as String,
      distance: (data['distance'] as num).toDouble(), 
      imageUrl: data['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'distance': distance,
      'imageUrl': imageUrl,
    };
  }
}