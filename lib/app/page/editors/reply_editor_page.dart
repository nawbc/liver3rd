// import 'package:flutter/material.dart';
// import 'package:liver3rd/app/widget/common_widget.dart';
// import 'package:liver3rd/custom/navigate/navigate.dart';

// class ReplyEditorPage extends StatefulWidget {
//   final String replyTarget;
//   const ReplyEditorPage({Key key, this.replyTarget}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _ReplyEditorPageState();
//   }
// }

// class _ReplyEditorPageState extends State<ReplyEditorPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: CommonWidget.titleText('回复'),
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[],
//         ),
//       ),
//     );
//   }
// }

// Handler replyPageHandler = Handler(
//   transactionType: TransactionType.fromLeft,
//   pageBuilder: (BuildContext context, arg) {
//     return ReplyEditorPage();
//   },
// );
