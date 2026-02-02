import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';
import 'package:lucky/screens/busqueda.dart';
import 'package:lucky/screens/carrito.dart';
import 'package:lucky/screens/catalogo.dart';
import 'package:lucky/screens/cupones.dart';
import 'package:lucky/screens/detalles_producto.dart';
import 'package:lucky/screens/favoritos.dart';
import 'package:lucky/screens/iniciar_sesion.dart';
import 'package:lucky/screens/pagina_principal.dart';
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
        return const PaginaPrincipal();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'busqueda',
          builder: (BuildContext context, GoRouterState state) {
            return const Busqueda();
          },
        ),
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
        GoRoute(
          path: 'favoritos',
          builder: (BuildContext context, GoRouterState state) {
            return const Favoritos();
          },
        ),
        GoRoute(
          path: 'cupones',
          builder: (BuildContext context, GoRouterState state) {
            return const Cupones();
          },
        ),
        GoRoute(
          path: 'detallesProducto',
          builder: (BuildContext context, GoRouterState state) {
            final producto = state.extra as Map<String, dynamic>;
            return DetallesProducto(producto: producto);
          },
        ),
        GoRoute(
          path: 'carrito',
          builder: (BuildContext context, GoRouterState state) {
            return const Carrito();
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CarritoProvider())],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Lucky',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFED1C24),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
