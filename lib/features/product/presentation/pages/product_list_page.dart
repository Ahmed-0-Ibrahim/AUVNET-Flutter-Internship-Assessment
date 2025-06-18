import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_internship_task/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_internship_task/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_internship_task/features/cart/presentation/bloc/cart_event.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../data/models/product_model.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProductBloc()..add(LoadProductsEvent()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            AddToCartEvent(
                              CartItemModel(
                                idUser: FirebaseAuth.instance.currentUser!.uid,
                                id: product.id,
                                name: product.name,
                                price: product.price,
                                quantity: 1,
                                imageUrl: product.imageUrl,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                            ),
                          );
                        },
                        child: const Text('Add to Cart'),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productDetails',
                          arguments: product,
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No products available.'));
          },
        ),
      ),
    );
  }
}
