
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ScreenUser/HomeScreenUser.dart';
class ModelScreenManageUser extends StatefulWidget {
  const ModelScreenManageUser({Key? key}) : super(key: key);

  @override
  _ModelScreenManageUserState createState() => _ModelScreenManageUserState();
}

class _ModelScreenManageUserState extends State<ModelScreenManageUser> {

  double screenHeight = 0;
  double screenWidth = 0;


  int currentIndex = 0;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.wallet,
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
            new HomeScreenUser(),
           // new AddItem(),
           // new MyDashboard(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 24,

          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2,2),
              )
            ],
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