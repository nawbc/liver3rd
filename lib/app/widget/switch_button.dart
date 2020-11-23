// import 'package:custom_switch_button/custom_switch_button.dart';
// import 'package:flutter/material.dart';

// class SwitchButton extends StatefulWidget {
//   final Function onChange;
//   final bool checked;

//   SwitchButton({this.onChange, this.checked});

//   @override
//   State<StatefulWidget> createState() {
//     return _SwitchButtonState(
//         onChange: onChange ?? () {}, checked: checked ?? false);
//   }
// }

// class _SwitchButtonState extends State<SwitchButton> {
//   Function onChange;
//   bool checked;

//   _SwitchButtonState({this.onChange, this.checked});

//   void _handleOnChange() {
//     onChange(checked);
//     setState(() {
//       checked = !checked;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _handleOnChange,
//       child: CustomSwitchButton(
//         backgroundColor: Colors.blue[200],
//         unCheckedColor: Colors.white,
//         animationDuration: Duration(milliseconds: 400),
//         checkedColor: Colors.white,
//         checked: checked,
//       ),
//     );
//   }
// }
