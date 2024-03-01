import 'package:ayrastore/Admin/Screen/listScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Admin/Screen/CRUD/UploadItemScreen.dart';
import 'Admin/Screen/CRUD/moneyUpdateScreen.dart';
import 'Admin/Screen/HomeScreen.dart';
import 'User/ScreenUser/FAQupdate.dart';
class ModelScreenManage extends StatefulWidget {
  const ModelScreenManage({Key? key}) : super(key: key);

  @override
  _ModelScreenState createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreenManage> {

  double screenHeight = 0;
  double screenWidth = 0;


  int currentIndex = 0;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.upload,
    FontAwesomeIcons.list,
  ];


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: currentIndex,
          children: [
            new HomeScreen(),
            new UploadBagScreen(),
            new ListScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 40,
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 15,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(const Radius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i< navigationIcons.length; i++)...<Expanded>{
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                navigationIcons[i],
                                color: i == currentIndex ? Colors.deepPurple : Colors.purple,
                                size: i == currentIndex ? 30 : 26,
                              ),
                              i == currentIndex ? Container(
                                margin: EdgeInsets.only(top: 6),
                                height: 3,
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                                  color: Colors.purple,

                                ),
                              ) : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                }
              ],
            ),
          ),
        ),

      ),
    );
  }
}