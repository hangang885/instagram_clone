import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(360, 680),
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            builder: (context, child2) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: child2!);
            },

          );
        });
  }
}
