import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductBloc() : super(ProductInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        QuerySnapshot snapshot = await _firestore.collection('products').get();
        List<ProductModel> products =
            snapshot.docs.map((doc) {
              return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to load products: ${e.toString()}'));
      }
    });
  }
}
