import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/widgets/rounded_button.dart';

final _firestore = FirebaseFirestore.instance;

class BuyingSucceeded extends StatefulWidget {
  const BuyingSucceeded({super.key});

  @override
  State<BuyingSucceeded> createState() => _BuyingSucceededState();
}

class _BuyingSucceededState extends State<BuyingSucceeded> {
  void senData() async {
    await _firestore.collection('invoice').add({
      'date': invoice.date,
      'creditCard': invoice.creditCard,
      'total': invoice.total,
      'customerId': invoice.customerId,
      'inVoiceId': invoice.inVoiceId,
    });

    for (var item in orders) {
      await _firestore.collection('orders').add({
        'inVoiceId': item.inVoiceId,
        'songId': item.songId,
        'orderId': item.orderId,
      });
    }
  }

//Send invoice and orders information to firestore...
  @override
  void initState() {
    super.initState();
    senData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 75,
          ),
          const Center(
            child: Text(
              'Success !',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Invoice Details',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Customer Name: ${currentUser.fName} ${currentUser.lName}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Center(
                  child: Text(
                    'Customer ID:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    invoice.customerId,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    'Date: ${invoice.date} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Center(
                  child: Text(
                    'Invoice ID:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    invoice.inVoiceId,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Orders Details',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Number of Orders: ${orders.length}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Center(
                  child: Text(
                    '________________________________',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, index) => Column(
                      children: [
                        const Center(
                          child: Text(
                            'Odrer ID:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text(
                            orders[index].orderId,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Song Name: ${songs.singleWhere(
                                  (element) => element.songId
                                      .contains(orders[index].songId),
                                ).title}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Price: ${songs.singleWhere(
                                  (element) => element.songId
                                      .contains(orders[index].songId),
                                ).price}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const Center(
                          child: Text(
                            '___________',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          RoundedButton(
            title: 'Back To Store',
            colour: Colors.lightBlueAccent,
            onPressed: () {
              cart.clear();
              orders.clear();

              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const ViewPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
