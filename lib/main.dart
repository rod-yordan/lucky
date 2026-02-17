import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/providers/favoritos_provider.dart';
import 'package:lucky/utils/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';
import 'package:lucky/screens/main_layout.dart';
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
  ApiClient.init(); // Inicializar Dio con interceptores
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => FavoritosProvider()),
      ],
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

final _router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const PaginaPrincipal(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalogo',
              builder: (context, state) => const Catalogo(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cupones',
              builder: (context, state) => const Cupones(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favoritos',
              builder: (context, state) => const Favoritos(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/iniciarSesion',
              builder: (context, state) => const IniciarSesion(),
            ),
            GoRoute(
              path: '/registroUsuario',
              builder: (context, state) => const RegistroUsuario(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(path: '/busqueda', builder: (context, state) => const Busqueda()),
    GoRoute(
      path: '/detallesProducto',
      builder: (context, state) {
        final producto = state.extra as Map<String, dynamic>;
        return DetallesProducto(producto: producto);
      },
    ),
    GoRoute(path: '/carrito', builder: (context, state) => const Carrito()),
  ],
);