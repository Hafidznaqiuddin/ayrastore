import 'package:cloud_firestore/cloud_firestore.dart';

class BrandService {
  final CollectionReference _brandCollection =
  FirebaseFirestore.instance.collection('Brand');

  Future<void> addBrand(String id, String brandName) async {
    await _brandCollection.doc(id).set({
      'id': id,
      'Brand': brandName,
    });
  }

  Future<List<Map<String, dynamic>>> getAllBrands() async {
    QuerySnapshot querySnapshot = await _brandCollection.get();
    List<Map<String, dynamic>> brands = [];
    querySnapshot.docs.forEach((doc) {
      brands.add(doc.data() as Map<String, dynamic>);
    });
    return brands;
  }

  Future<void> updateBrand(String id, String brandName) async {
    await _brandCollection.doc(id).update({
      'Brand': brandName,
    });
  }

  Future<void> deleteBrand(String id) async {
    await _brandCollection.doc(id).delete();
  }
}