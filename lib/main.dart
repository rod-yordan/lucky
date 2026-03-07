// main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/providers/auth_provider.dart';
import 'package:lucky/providers/favoritos_provider.dart';
import 'package:lucky/providers/generos_provider.dart';
import 'package:lucky/screens/catalogo_parte2.dart';
import 'package:lucky/screens/informacion_compra.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';
import 'package:lucky/screens/main_layout.dart';
import 'package:lucky/screens/busqueda.dart';
import 'package:lucky/screens/carrito.dart';
import 'package:lucky/screens/catalogo_parte1.dart';
import 'package:lucky/screens/cupones.dart';
import 'package:lucky/screens/detalles_producto.dart';
import 'package:lucky/screens/favoritos.dart';
import 'package:lucky/screens/iniciar_sesion.dart';
import 'package:lucky/screens/pagina_principal.dart';
import 'package:lucky/screens/registro_usuario.dart';
import 'package:lucky/screens/perfil.dart';
import 'package:lucky/services/pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefService = PrefService();
  await prefService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => FavoritosProvider()),
        ChangeNotifierProvider(create: (_) => GenerosProvider()),
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
        // Branch: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const PaginaPrincipal(),
            ),
          ],
        ),
        // Branch: Catálogo
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalogo',
              name: 'catalogo',
              builder: (context, state) => const CatalogoParte1(),
            ),
          ],
        ),
        // Branch: Cupones
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cupones',
              name: 'cupones',
              builder: (context, state) => const Cupones(),
            ),
          ],
        ),
        // Branch: Favoritos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favoritos',
              name: 'favoritos',
              builder: (context, state) => const Favoritos(),
            ),
          ],
        ),
        // Branch: Cuenta
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cuenta',
              name: 'cuenta',
              redirect: (context, state) {
                // 🔹 IMPORTANTE: No redirigir si está yendo a registroUsuario
                if (state.fullPath == '/cuenta/registroUsuario') {
                  return null; // Permite la navegación a registro
                }

                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );

                if (!authProvider.isLoggedIn) {
                  return '/cuenta/iniciarSesion';
                }
                return '/cuenta/perfil';
              },
              routes: [
                GoRoute(
                  path: 'perfil',
                  name: 'perfil',
                  builder: (context, state) => const Perfil(),
                ),
                GoRoute(
                  path: 'iniciarSesion',
                  name: 'login',
                  builder: (context, state) => const IniciarSesion(),
                ),
                GoRoute(
                  path: 'registroUsuario',
                  name: 'registro',
                  builder: (context, state) => const RegistroUsuario(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // RUTAS FUERA DEL SHELL (SIN BARRA INFERIOR)
    GoRoute(
      path: '/carrito',
      name: 'carrito',
      builder: (context, state) => const Carrito(),
    ),
    GoRoute(
      path: '/busqueda',
      name: 'busqueda',
      builder: (context, state) => const Busqueda(),
    ),
    GoRoute(
      path: '/detallesProducto',
      name: 'detalle',
      builder: (context, state) {
        final producto = state.extra as Map<String, dynamic>;
        return DetallesProducto(producto: producto);
      },
    ),
    GoRoute(
      path: '/informacionCompra',
      name: 'informacionCompra',
      builder: (context, state) => const InformacionCompra(),
    ),
    GoRoute(
      path: '/catalogo-parte2',
      name: 'catalogoParte2',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CatalogoParte2(
          genero: extra['genero'],
          generoId: extra['generoId'],
        );
      },
    ),
  ],
);
