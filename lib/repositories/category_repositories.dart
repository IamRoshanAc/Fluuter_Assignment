import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Burger", status: "active", imageUrl: "https://myrepublica.nagariknetwork.com/uploads/media/2017/September/burger11.jpg"),
        CategoryModel(categoryName: "Snacks", status: "active", imageUrl: "https://d1ralsognjng37.cloudfront.net/7817363a-a8d9-4bf3-b9ff-a2fa9c1a0722.webp"),
        CategoryModel(categoryName: "Beverages", status: "active", imageUrl: "https://www.thespruceeats.com/thmb/MmDghXG76LQVYRsTEtjW3frzgbg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/bar101-cocktails-504754220-580e83415f9b58564cf470b9.jpg"),
       ];
  }



}