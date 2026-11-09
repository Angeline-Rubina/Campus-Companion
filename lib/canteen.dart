
import 'package:flutter/material.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({super.key});

  @override
  State<CanteenScreen> createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final List<Map<String, dynamic>> menu = [
    {'name': 'Idli', 'price': 10, 'qty': 0},
    {'name': 'Dosa', 'price': 30, 'qty': 0},
    {'name': 'Pongal', 'price': 25, 'qty': 0},
    {'name': 'Meals', 'price': 60, 'qty': 0},
    {'name': 'Chicken Rice', 'price': 80, 'qty': 0},
    {'name': 'Egg Rice', 'price': 50, 'qty': 0},
    {'name': 'Tea', 'price': 10, 'qty': 0},
    {'name': 'Coffee', 'price': 15, 'qty': 0},
  ];

  int get total {
    int amount = 0;

    for (var item in menu) {
      amount += item['price'] * item['qty'] as int;
    }

    return amount;
  }

  void changeQuantity(int index, int value) {
    setState(() {
      menu[index]['qty'] =
          (menu[index]['qty'] as int) + value;

      if (menu[index]['qty'] < 0) {
        menu[index]['qty'] = 0;
      }
    });
  }

  void resetOrder() {
    setState(() {
      for (var item in menu) {
        item['qty'] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),

      appBar: AppBar(
        title: const Text('College Canteen'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: menu.length,

              itemBuilder: (context, index) {
                final item = menu[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.restaurant,
                      color: Colors.orange,
                    ),

                    title: Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '₹${item['price']}',
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          onPressed: () {
                            changeQuantity(index, -1);
                          },
                          icon: const Icon(Icons.remove),
                        ),

                        Text(
                          '${item['qty']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            changeQuantity(index, 1);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.orange.shade100,

            child: Column(
              children: [
                Text(
                  'Total Bill: ₹$total',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: resetOrder,
                  child: const Text('Clear Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
