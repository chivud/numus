import 'package:experiment/entities/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAmountScreen extends StatelessWidget {
  final Category category;

  AddAmountScreen({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add ${category.name} amount')),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: AmountWidget(),
      ),
    );
  }
}

class AmountWidget extends StatefulWidget {
  @override
  _AmountWidgetState createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
  @override
  Widget build(BuildContext context) {
    return CalculatorWidget();
  }
}

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String value = '0';

  void onKeyPress(String character) {
    if (value.length > 10) {
      return;
    }

    if ((character == ',' || character == '.') &&
        (value.contains(',') || value.contains('.'))) {
      return;
    }

    if (character == 'AC') {
      setState(() {
        value = '0';
      });
    } else if (value == '0') {
      setState(() {
        value = character;
      });
    } else {
      setState(() {
        value = value + character;
      });
    }
  }

  void onBackspacePress() {
    if(value.length > 1){
      setState(() {
        value = value.substring(0, value.length - 1);
      });
    }else{
      setState(() {
        value = '0';
      });
    }

  }

  void onDonePress() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  ' lei',
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '7',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '4',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '1',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: ',',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '8',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '5',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '2',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '0',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '9',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '6',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '3',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '.',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CalculatorAction(
                      icon: Icon(Icons.backspace_outlined),
                      onPress: onBackspacePress,
                    ),
                    CalculatorKey(
                      character: 'AC',
                      onPress: onKeyPress,
                    ),
                    CalculatorAction(
                      flex: 2,
                      icon: Icon(Icons.done),
                      onPress: onDonePress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalculatorKey extends StatelessWidget {
  final Function onPress;

  final String character;

  final int flex;

  CalculatorKey({this.character, this.onPress, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          // height: 80,
          child: Text(
            character,
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            onPress(character);
          },
        ),
      ),
    );
  }
}

class CalculatorAction extends StatelessWidget {
  final Function onPress;

  final Icon icon;

  final int flex;

  CalculatorAction({this.icon, this.onPress, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          disabledBorderColor: Colors.green,
          child: icon,
          onPressed: () => {onPress()},
        ),
      ),
    );
  }
}
