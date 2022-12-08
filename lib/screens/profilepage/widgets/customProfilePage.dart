import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {Key? key,
      required this.pages,
      required this.text,
      required this.isLogOut})
      : super(key: key);
  String pages, text;
  bool isLogOut;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 175,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              isLogOut
                  ? {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            actions: [
                              Lottie.asset('assets/logout.json'),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Are you sure?',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, pages);
                                          Auth().logOut();
                                        },
                                        child: Text('Yes')),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    }
                  : Navigator.pushNamed(context, pages);
            },
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            )),
      ),
    );
  }
}
