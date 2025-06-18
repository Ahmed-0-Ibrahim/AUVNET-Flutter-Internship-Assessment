import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartBloc() : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          emit(CartError('User not authenticated.'));
          return;
        }
        print('Fetching cart items for user: ${currentUser.uid}');
        QuerySnapshot snapshot =
            await _firestore
                .collection('cart')
                .where('idUser', isEqualTo: currentUser.uid)
                .get();
        print('Snapshot data: ${snapshot.docs.map((doc) => doc.data())}');
        List<CartItemModel> items =
            snapshot.docs.map((doc) {
              return CartItemModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
        print('Cart items: ${items.map((item) => item.toJson())}');
        // Cache cart items in Hive
        final cartBox = Hive.box('cart');
        cartBox.put('cartItems', items.map((c) => c.toJson()).toList());
        emit(CartLoaded(items));
      } catch (e) {
        print('Error fetching cart items: $e');
        // Load cached cart items if Firebase fetch fails
        final cartBox = Hive.box('cart');
        final cachedCartItems = cartBox.get('cartItems', defaultValue: []);
        if (cachedCartItems.isNotEmpty) {
          final cartItems =
              cachedCartItems.map((c) => CartItemModel.fromJson(c)).toList();
          emit(CartLoaded(cartItems));
        } else {
          emit(CartError('Failed to load cart items.'));
        }
      }
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        await _firestore
            .collection('cart')
            .doc(event.item.id)
            .set(event.item.toJson());
        add(LoadCartEvent()); // Reload cart after adding
      } catch (e) {
        emit(CartError('Failed to add item to cart: ${e.toString()}'));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      try {
        await _firestore.collection('cart').doc(event.itemId).delete();
        add(LoadCartEvent()); // Reload cart after removing
      } catch (e) {
        emit(CartError('Failed to remove item from cart: ${e.toString()}'));
      }
    });
  }
}
