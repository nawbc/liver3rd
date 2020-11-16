import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/menu_button_lib.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class MenuButton extends StatefulWidget {
  final List itemsList;
  final double height;
  final double width;
  final Function(dynamic) onSelected;
  final dynamic initialItem;
  final Function(int) onItemPressed;
  final BoxDecoration decoration;
  final Widget child;
  final MainAxisAlignment mainAxisAlignment;

  const MenuButton({
    Key key,
    @required this.itemsList,
    this.height = 40,
    this.width = 80,
    this.onSelected,
    this.initialItem,
    this.onItemPressed,
    this.decoration = const BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      color: Color(0xffeeeeee),
    ),
    this.child,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MenuButtonState();
  }
}

class _MenuButtonState extends State<MenuButton> {
  var _splashSelectedItem;
  initState() {
    super.initState();
    _splashSelectedItem = widget.itemsList[0];
  }

  Widget _splashSelectButton(String content) => Container(
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          children: <Widget>[
            NoScaledText(content, style: TextStyle(color: Colors.grey)),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MenuButtonLib(
      child: widget.child == null
          ? (_splashSelectedItem is String
              ? _splashSelectButton(_splashSelectedItem)
              : _splashSelectedItem)
          : widget.child,
      items: widget.itemsList,
      popupHeight: (widget.itemsList.length + 1) * widget.height,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (item) => Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: item is Widget
            ? item
            : Center(
                child:
                    NoScaledText(item, style: TextStyle(color: Colors.grey))),
      ),
      toggledChild: Container(
        color: Colors.grey[200],
        child: (_splashSelectedItem is String
            ? _splashSelectButton(_splashSelectedItem)
            : _splashSelectedItem),
      ),
      divider: Container(
        height: 0,
        color: Colors.white,
      ),
      onItemSelected: (value) {
        if (widget.onSelected != null) widget.onSelected(value);
        setState(() {
          _splashSelectedItem = value;
        });
      },
      decoration: widget.decoration,
      onItemPressed: widget.onItemPressed,
      onMenuButtonToggle: (isToggle) {},
    );
  }
}
