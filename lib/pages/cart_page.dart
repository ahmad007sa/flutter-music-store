import 'package:flutter/material.dart';

import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/credit_card_page.dart';
import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/widgets/rounded_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //delete son from Cart
  void deleteItem(Song item) {
    setState(() {
      cart.remove(item);
      calculateTotal(cart);
    });
  }

//calculate total for invoice...
  void calculateTotal(List<Song> cart) {
    int sum = 0;
    for (var item in cart) {
      sum = sum + item.price;
    }
    setState(() {
      total = sum;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateTotal(cart);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = cart.isEmpty
        ? const Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: 30,
                child: Center(
                    child: Text(
                  'swipe left to delete...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (ctx, index) => Dismissible(
                    key: ValueKey(index),
                    //delete item by swip left or right ...
                    onDismissed: (direction) {
                      deleteItem(cart[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        tileColor: Colors.blueAccent.shade100,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cart[index].type),
                          ],
                        ),
                        title: Text(cart[index].title),
                        leading: const Icon(Icons.music_note),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${cart[index].price} SP',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Display total for invoice...
              Center(
                child: Text('Total=$total'),
              ),
              //Button to move to credit card page...
              RoundedButton(
                title: 'CHECK OUT',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const CreditCardPage();
                      },
                    ),
                  );
                },
              )
            ],
          );

    return Scaffold(
      body: content,
    );
  }
}
