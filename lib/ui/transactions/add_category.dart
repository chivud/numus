import 'package:flutter/services.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/services/CategoryService.dart';
import 'package:flutter/material.dart';
import 'package:numus/constants/icons.dart';

const Color initialColor = Colors.green;

/// This is garbage and need to be rewritten.
class AddCategoryWidget extends StatefulWidget {
  final CategoryType categoryType;
  final Category category;

  AddCategoryWidget(this.categoryType, {this.category});

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final _formKey = GlobalKey<FormState>();

  Icon icon;

  ColorPickerWidget selectedColorPicker;

  List<ColorPickerWidget> colorPickers;

  final textFieldController = TextEditingController();

  void addCategory(String categoryName, int icon, int color) {
    if (widget.category == null) {
      CategoryService()
          .createCategory(widget.categoryType, categoryName, icon, color)
          .then((value) => Navigator.pop(
                context,
              ));
    } else {
      widget.category.name = categoryName;
      widget.category.icon = icon;
      widget.category.color = color;
      CategoryService()
          .editCategory(widget.category)
          .then((value) => Navigator.pop(
                context,
              ));
    }
  }

  @override
  void initState() {
    colorPickers = iconColors.map((Color color) {
      if (widget.category == null) {
        if (color.hashCode == initialColor.hashCode) {
          selectedColorPicker = ColorPickerWidget(
            color,
            changeSelectedColorPicker,
            selected: true,
          );
          return selectedColorPicker;
        }
        return ColorPickerWidget(color, changeSelectedColorPicker);
      }

      if (Color(widget.category.color).value == color.value) {
        selectedColorPicker = ColorPickerWidget(
          color,
          changeSelectedColorPicker,
          selected: true,
        );
        return selectedColorPicker;
      }
      return ColorPickerWidget(color, changeSelectedColorPicker);
    }).toList();
    textFieldController.text =
        widget.category != null ? widget.category.name : null;
    icon = widget.category != null
        ? Icon(IconData(widget.category.icon, fontFamily: 'MaterialIcons'))
        : Icon(Icons.attach_money);
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
              children: icons
                  .map(
                    (IconData iconData) => IconWidget(
                        Icon(iconData), selectedColorPicker.color, selectIcon),
                  )
                  .toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.category == null
            ? Text(
                'Add ' + widget.categoryType.name.toLowerCase() + ' category')
            : Text('Edit ' + widget.category.name + ' category'),
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
                  hintText: 'Category Name...',
                ),
                style: TextStyle(fontSize: 20),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _formKey.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name for your category';
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
