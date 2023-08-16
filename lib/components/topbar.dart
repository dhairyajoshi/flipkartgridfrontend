// ignore_for_file: prefer_const_constructors

import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flipkartgridfrontend/screens/orders.dart';
import 'package:flipkartgridfrontend/screens/products.dart';
import 'package:flipkartgridfrontend/screens/profile.dart';
import 'package:flipkartgridfrontend/screens/rewards.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => ProductScreen()))),
            child: Image(
              image: AssetImage('../assets/logo.png'),
              height: 50,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextField(
                // controller: controller,
                // onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white, // Set the background color to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.person),
            offset: Offset(0, 40),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'Orders',
                  child: Text('Orders'),
                ),
                PopupMenuItem<String>(
                  value: 'Reward',
                  child: Text('Reward History'),
                ),
                PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (String result) {
              if (result == 'Profile') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => ProfileScreen())));
              } else if (result == 'Orders') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => OrderScreen())));
              } else if (result == 'Reward') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => RewardScreen())));
              } else if (result == 'Logout') {
                DatabaseService().logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => LoginScreen())));
              }
            },
          )
        ],
      ),
    );
  }
}
