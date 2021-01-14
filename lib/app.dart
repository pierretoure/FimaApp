import 'package:FimaApp/screens/HomeScreen/HomeScreen.dart';
import 'package:FimaApp/screens/ProfileScreen/ProfileScreen.dart';
import 'package:FimaApp/screens/ShoppingScreen/ShoppingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FimaApp extends HookWidget {
    @override
    Widget build(BuildContext context) {
        final index = useState<int>(1);
        final screens = [
            ShoppingScreen(),
            HomeScreen(),
            ProfileScreen(),
        ];
        return Scaffold(
            body: screens[index.value],
            bottomNavigationBar: Container(                                                  
                child: ClipRRect(
                    child:BottomNavigationBar(
                        items: [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.shopping_bag_outlined),
                                label: 'courses'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.home_outlined),
                                label: 'home'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.self_improvement_outlined),
                                label: 'profil')],
                        onTap: (idx) => index.value = idx,
                        currentIndex: index.value,
                        iconSize: 34,
                        type: BottomNavigationBarType.fixed,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32), 
                        topRight: Radius.circular(32), 
                    ),
                ),
                decoration: BoxDecoration(                                                   
                    borderRadius: BorderRadius.only(                                           
                        topRight: Radius.circular(32), 
                        topLeft: Radius.circular(32)),            
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black12, 
                            spreadRadius: 0, 
                            blurRadius: 15,
                        ),
                    ],
                ),
            ),
            backgroundColor: Color(0xfff5f5f5),// Colors.grey[50],
            resizeToAvoidBottomInset: false,
        );
    }
}
