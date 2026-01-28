import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/catalogo.dart';
import 'package:lucky/screens/iniciar_sesion.dart';
import 'package:lucky/screens/my_home_page.dart';
import 'package:lucky/screens/registro_usuario.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: "C'Lucky");
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'registroUsuario',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistroUsuario();
          },
        ),
        GoRoute(
          path: 'iniciarSesion',
          builder: (BuildContext context, GoRouterState state) {
            return const IniciarSesion();
          },
        ),
        GoRoute(
          path: 'catalogo',
          builder: (BuildContext context, GoRouterState state) {
            return const Catalogo();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

