import 'package:flutter_internship_task/features/product/data/models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products; // List of products with details
  HomeLoaded(this.products);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
