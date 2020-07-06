import 'package:flutter/material.dart';
import 'package:liver3rd/app/store/animations.dart';
import 'package:liver3rd/app/store/emojis.dart';

import 'package:liver3rd/app/store/posts.dart';
import 'package:liver3rd/app/store/settings.dart';
import 'package:liver3rd/app/store/tim.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/store/comics.dart';

import 'package:liver3rd/app/store/valkyries.dart';
import 'package:liver3rd/app/store/wallpapers.dart';
import 'package:liver3rd/app/store/redemption.dart';
import 'package:provider/provider.dart';

class Storager {
  static BuildContext widgetContext;
  Widget child;

  static MultiProvider init({context, child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Valkyries>(
          create: (_) => Valkyries(),
        ),
        ChangeNotifierProvider<Redemption>(
          create: (_) => Redemption(),
        ),
        ChangeNotifierProvider<User>(
          create: (_) => User(),
        ),
        ChangeNotifierProvider<Comics>(
          create: (_) => Comics(),
        ),

        ChangeNotifierProvider<Wallpapers>(
          create: (_) => Wallpapers(),
        ),
        ChangeNotifierProvider<Animations>(
          create: (_) => Animations(),
        ),
        // ChangeNotifierProvider<Notifications>(
        //   create: (_) => Notifications(),
        // ),
        ChangeNotifierProvider<Posts>(
          create: (_) => Posts(),
        ),
        ChangeNotifierProvider<Emojis>(
          create: (_) => Emojis(),
        ),
        ChangeNotifierProvider<Tim>(
          create: (_) => Tim(),
        ),
        ChangeNotifierProvider<Settings>(
          create: (_) => Settings(),
        ),
      ],
      child: child,
    );
  }
}