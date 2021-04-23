import 'package:flutter/material.dart';
import 'package:numus/constants/currencies.dart';
import 'package:numus/ui/wizard/currency_picker.dart';

class GetStartedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 150, left: 40, right: 40),
                child: Image.asset('assets/logo.png'),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text('Welcome!', style: TextStyle(
                    fontSize: 24
                  ),),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Text('Start tracking your income, expenses and savings with just a few taps.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 18,
                  ),),
                ),
              ),
            ],
          )
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(40),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15)),
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurrencyPickerWidget(currencies)))
              },
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
