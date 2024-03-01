import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
  FirebaseFirestore.instance.collection('Category');

  Future<void> addCategory(String id, String categoryName) async {
    await _categoryCollection.doc(id).set({
      'id': id,
      'category': categoryName,
    });
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    QuerySnapshot querySnapshot = await _categoryCollection.get();
    List<Map<String, dynamic>> categories = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        String categoryName = data['category'] ?? 'Unknown Category';
        data['category'] = categoryName;
        categories.add(data);
      }
    });
    return categories;
  }

  Future<void> updateCategory(String id, String categoryName) async {
    await _categoryCollection.doc(id).update({
      'category': categoryName,
    });
  }

  Future<void> deleteCategory(String id) async {
    await _categoryCollection.doc(id).delete();
  }
}
