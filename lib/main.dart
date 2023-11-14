import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent
              ),
              child: BottomNavigationBar(
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: false,
                iconSize: 20.w,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search),label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.movie_creation_outlined),label: ''
                  ),BottomNavigationBarItem(
                      icon: Icon(Icons.send),label: ''
                  ),BottomNavigationBarItem(
                      icon: Icon(Icons.image_outlined),label: ''
                  ),
                ],
                currentIndex: navigationShell.currentIndex,
                onTap: (int index2) {
                  navigationShell.goBranch(index2);
                  // 브랜치를 전환하는데는 StatefulNavigationShell.goBranch 메서드를 사용한다.
                },
              ),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/two',
                builder: (BuildContext context, GoRouterState state) =>
                 Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/three',
                builder: (BuildContext context, GoRouterState state) =>
                 Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/four',
                builder: (BuildContext context, GoRouterState state) =>
                    Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/five',
                builder: (BuildContext context, GoRouterState state) =>
                    Container(),
              ),
            ],
          ),
        ])
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(360, 680),
        builder: (context, child) {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
          );
          return MaterialApp.router(
            themeMode: ThemeMode.dark,
            //다크모드설정
            darkTheme: ThemeData.dark(useMaterial3: false),
            title: 'Flutter Demo',
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            builder: (context, child2) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: child2!);
            },
          );
        });
  }
}
