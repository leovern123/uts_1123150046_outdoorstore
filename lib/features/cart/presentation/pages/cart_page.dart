import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../../product/data/models/product_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _formatPrice(double price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }

    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text("Keranjang masih kosong"),
            )
          : Column(
              children: [

                //list product
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final ProductModel item = cart.items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(

                          //image
                          leading: item.imageUrl.isNotEmpty
                              ? Image.network(
                                  item.imageUrl,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image),

                          //name
                          title: Text(item.name),

                          //price
                          subtitle: Text(_formatPrice(item.price)),

                          //delete
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<CartProvider>().removeFromCart(item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //total dan chekout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    children: [

                      //total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatPrice(cart.totalPrice),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      //checkout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Checkout"),
                                content: const Text(
                                    "Checkout berhasil! 🎉"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const Text("Checkout"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}