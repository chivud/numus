import 'package:numus/entities/category_type.dart';
import 'package:numus/services/CategoryService.dart';
import 'package:flutter/material.dart';

/// This is garbage and need to be rewritten.
class AddCategoryWidget extends StatefulWidget {
  final CategoryType categoryType;

  AddCategoryWidget(this.categoryType);

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final _formKey = GlobalKey<FormState>();

  Icon icon = Icon(Icons.attach_money);

  ColorPickerWidget selectedColorPicker;

  List<ColorPickerWidget> colorPickers;

  final textFieldController = TextEditingController();

  void addCategory(String categoryName, int icon, int color) {
    CategoryService()
        .createCategory(widget.categoryType, categoryName, icon, color)
        .then((value) => Navigator.pop(context, ));
  }

  @override
  void initState() {
    colorPickers = [
      ColorPickerWidget(Colors.green, changeSelectedColorPicker,
          selected: true),
      ColorPickerWidget(Colors.red, changeSelectedColorPicker),
      ColorPickerWidget(Colors.blue, changeSelectedColorPicker),
      ColorPickerWidget(Colors.amber, changeSelectedColorPicker),
      ColorPickerWidget(Colors.blueGrey, changeSelectedColorPicker),
      ColorPickerWidget(Colors.purple, changeSelectedColorPicker),
      ColorPickerWidget(Colors.deepOrange, changeSelectedColorPicker),
    ];
    selectedColorPicker = colorPickers.first;
    super.initState();
  }

  void changeSelectedColorPicker(ColorPickerWidget colorPickerWidget) {
    this.setState(() {
      int selectedIndex = colorPickers.indexOf(selectedColorPicker);
      int newSelectedIndex = colorPickers.indexOf(colorPickerWidget);
      colorPickers[selectedIndex] = ColorPickerWidget(
          selectedColorPicker.color, changeSelectedColorPicker);
      selectedColorPicker = ColorPickerWidget(
        colorPickerWidget.color,
        changeSelectedColorPicker,
        selected: true,
      );
      colorPickers[newSelectedIndex] = selectedColorPicker;
    });
  }

  void selectIcon(IconWidget w) {
    setState(() {
      icon = w.icon;
      Navigator.pop(context);
    });
  }

  void showIconSelection(IconWidget w) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: GridView.count(
              crossAxisCount: 5,
              children: [
                IconWidget(Icon(Icons.account_balance),
                    selectedColorPicker.color, selectIcon),
                IconWidget(Icon(Icons.bug_report), selectedColorPicker.color,
                    selectIcon),
                IconWidget(
                    Icon(Icons.build), selectedColorPicker.color, selectIcon),
                IconWidget(
                    Icon(Icons.commute), selectedColorPicker.color, selectIcon),
                IconWidget(Icon(Icons.credit_card), selectedColorPicker.color,
                    selectIcon),
                IconWidget(
                    Icon(Icons.eco), selectedColorPicker.color, selectIcon),
                IconWidget(Icon(Icons.event_seat), selectedColorPicker.color,
                    selectIcon),
                IconWidget(
                    Icon(Icons.explore), selectedColorPicker.color, selectIcon),
                IconWidget(Icon(Icons.favorite), selectedColorPicker.color,
                    selectIcon),
                IconWidget(Icon(Icons.flight_takeoff),
                    selectedColorPicker.color, selectIcon),
                IconWidget(
                    Icon(Icons.home), selectedColorPicker.color, selectIcon),
                IconWidget(Icon(Icons.lightbulb), selectedColorPicker.color,
                    selectIcon),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add ' + widget.categoryType.name.toLowerCase() + ' category'),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  addCategory(textFieldController.text, icon.icon.codePoint,
                      selectedColorPicker.color.value);
                }
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              IconWidget(icon, selectedColorPicker.color, showIconSelection),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Wrap(
                  children: colorPickers,
                ),
              ),
              TextFormField(
                controller: textFieldController,
                decoration: InputDecoration(
                  hintText: 'Category name...',
                ),
                style: TextStyle(fontSize: 20),
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _formKey.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  final Color iconColor;
  final Icon icon;
  final onPress;

  IconWidget(this.icon, this.iconColor, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
        child: IconButton(
            color: Colors.white,
            icon: icon,
            iconSize: 40,
            onPressed: () {
              onPress(this);
            }),
      ),
    );
  }
}

class ColorPickerWidget extends StatelessWidget {
  final Color color;
  final bool selected;
  final tapped;

  ColorPickerWidget(this.color, this.tapped, {this.selected: false});

  onPress() {
    tapped(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
          color: selected ? Colors.white : Colors.transparent,
          icon: Icon(Icons.done),
          onPressed: onPress),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
