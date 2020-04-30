import 'package:belafrikapp/templates/loginPage2.dart';
import 'package:belafrikapp/templates/widgets/onBoardingImageCliper.dart';
import 'package:flutter/material.dart';

class LoginPage1 extends StatefulWidget {
  @override
  _LoginPage1State createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: OnBoardingImageCliper(),
            child: Container(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.asset('assets/logo.jpg'),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.8),
                            Colors.black12.withOpacity(.05)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter
                        )
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 32.0, left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                    'BELAFRIKA',
                  style: Theme.of(context).textTheme.display1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 11.5
                  ),
                ),
                Text(
                  'Une Experience que jamais, '
                      'Exprimez votre avis en choisissant '
                      'selon votre intuition entre 2 bellas africaines '
                      'laquelle es-tu touché par sa magnifique beauté',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5.0,),
                MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage2()));
                  },
                  color: Colors.black,
                  child: Text(
                      'C\'EST PARTI ',
                    style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
