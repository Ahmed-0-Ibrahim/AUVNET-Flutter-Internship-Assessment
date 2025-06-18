import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_internship_task/features/product/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // Fetch data from Firestore
        QuerySnapshot snapshot = await _firestore.collection('products').get();
        List<ProductModel> products =
            snapshot.docs.map((doc) {
              return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
        // Cache products in Hive
        final productsBox = Hive.box('products');
        productsBox.put('products', products.map((p) => p.toJson()).toList());
        emit(HomeLoaded(products));
      } catch (e) {
        // Load cached products if Firebase fetch fails
        final productsBox = Hive.box('products');
        final cachedProducts = productsBox.get('products', defaultValue: []);
        if (cachedProducts.isNotEmpty) {
          final products =
              cachedProducts.map((p) => ProductModel.fromJson(p)).toList();
          emit(HomeLoaded(products));
        } else {
          emit(HomeError('Failed to load products.'));
        }
      }
    });
  }
}
