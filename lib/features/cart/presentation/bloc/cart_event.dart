import '../../data/models/cart_item_model.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItemModel item;

  AddToCartEvent(this.item);
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;

  RemoveFromCartEvent(this.itemId);
}
