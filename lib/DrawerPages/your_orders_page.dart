import 'dart:math';

import 'package:delivery/Classes/Products.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class YourOrders extends StatefulWidget {
  @override
  _YourOrdersState createState() => _YourOrdersState();
}

int i = 0;
List<Order> currOrders = [];
List<Order> pastOrders = [];
List<OrderItem> temp1 = [];
List<OrderItem> temp2 = [];

class _YourOrdersState extends State<YourOrders> {
  @override
  Widget build(BuildContext context) {
//------------------------------------------------------------------------------------------------------
    getOrderList();
    //------------------------------------------------------------------------------------------------------
//    setState(() {
//      if (currOrders[0].d.isEmpty) {
//        print('---------------d is empty------------');
//      } else {
//        print('---------------d is not empty------------');
//      }
//    });
    print('d ki length h ${currOrders[0].d.length}');
    for (i = 0; i < currOrders.length; i++) {
      for (int j = 0; j < currOrders[i].d.length; j++) {
        print(
            'OrderDetails Are ${currOrders[i].d[j].name} ${currOrders[i].d[j].price}');
      }
    }
    for (i = 0; i < pastOrders.length; i++) {
      for (int j = 0; j < pastOrders[i].d.length; j++) {
        print(
            'OrderDetails Are ${pastOrders[i].d[j].name} ${pastOrders[i].d[j].price}');
      }
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Past Orders',
            style: TextStyle(color: Color(0xFF345995)),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF345995),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: currOrders.isEmpty
            ? pastOrders.isEmpty
                ?
                //When both the orders list are empty
                Container(
                    color: Colors.white,
                    child: Center(
                        child: Text('Your past orders will be displayed')),
                  )
                :
                //Current orders are empty but we have past pastOrders
                Column(
                    children: <Widget>[
                      Text('Past Orders'),
//                      Text(pastOrders[0].d[0].name),
//                      Text(pastOrders[0].d[0].price),
                    ],
                  )
            : pastOrders.isEmpty
                ?
                //We have only current orders
                Column(
                    children: <Widget>[
                      Text('Current Orders'),
//                      Text(currOrders[0].d[0].name),
//                      Text(currOrders[0].d[0].price),
                    ],
                  )
                :
                //We have both current and past orders
                Column(
                    children: <Widget>[
                      Text('Current Orders'),
                      Text(currOrders.length.toString()),
                      Text(currOrders[0].d[0].price.toString()),
                      Text('Past Orders'),
                      Text(pastOrders.length.toString()),

                      Text(pastOrders[0].d.length.toString()),
//                      Text(pastOrders[0].d[0].price.toString()),
                    ],
                  ));
  }
}

void getOrderList() {
  DatabaseReference dailyitemsref =
      FirebaseDatabase.instance.reference().child('Orders');
  dailyitemsref.once().then((DataSnapshot snap) {
    // ignore: non_constant_identifier_names
    var KEYS = snap.value.keys;
    // ignore: non_constant_identifier_names
    var DATA = snap.value;
    currOrders.clear();
    pastOrders.clear();

    for (var key in KEYS) {
      temp1.clear();
      temp2.clear();
      //TODO: Change phone number

      if (DATA[key]['UserPhNo'] == '+917060222315') {
        if (DATA[key]['Status'] == 'notCompleted') {
          print('Order Length is ${DATA[key]['orderLength'].toString()}');
          for (i = 0; i < DATA[key]['orderLength']; i++) {
            OrderItem e = new OrderItem(
                DATA[key]['$i']['Name'], DATA[key]['$i']['Price']);
            temp1.add(e);
//              print('Order details are ${e.name} ${e.price}');
          }
        } else {
          print('Order Length is ${DATA[key]['orderLength'].toString()}');
          for (i = 0; i < DATA[key]['orderLength']; i++) {
            OrderItem e = new OrderItem(DATA[key][i.toString()]['Name'],
                DATA[key][i.toString()]['Price']);
            temp2.add(e);
//              print('Order details are ${e.name} ${e.price}');
          }
        }
      }
      if (temp1.isNotEmpty) {
//          Order t = Order(temp1);
        currOrders.add(createOrder(temp1));
        if (currOrders.isNotEmpty) {
          print(
              'Order added successfully currOrder Length is ${currOrders.length}');
          for (i = 0; i < currOrders.length; i++) {
            for (int j = 0; j < currOrders[i].d.length; j++) {
              print(
                  'OrderDetails Are ${currOrders[i].d[j].name} ${currOrders[i].d[j].price}');
            }
          }
        }
      }
      if (temp2.isNotEmpty) {
//          Order t = Order(temp2);
        print(temp2.length.toString());
        pastOrders.add(createOrder(temp2));
        if (pastOrders.isNotEmpty) {
          print(
              'Order added successfully pastOrder Length is ${pastOrders.length}');
          for (i = 0; i < pastOrders.length; i++) {
            for (int j = 0; j < pastOrders[i].d.length; j++) {
              print(
                  'OrderDetails Are ${pastOrders[i].d[j].name} ${pastOrders[i].d[j].price}');
            }
          }
        }
      }
    }
  });
}

Order createOrder(List<OrderItem> d) {
  Order temp = Order(d);
  return temp;
}
