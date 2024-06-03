import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/router/controller/route_controller.dart';
import 'package:fyp/utils/color/color_accent.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}



class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routerProvider);
    return FluentApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        scaffoldBackgroundColor: Colors.white,
        accentColor: ColorAccent.primaryShade,
      ),
      routerConfig: route,
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      home: NavigationView(
        appBar: NavigationAppBar(
          title: Text(
            'Fluent UI for Flutter',
            style: TextStyle(
              color: FluentTheme.of(context).accentColor.darkest,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(FluentIcons.home),
        ),
        content: ScaffoldPage(
          content: Center(
            child: Column(
              children: [
                Button(
                  child: const Text("Collector Screen"),
                  onPressed: () {
                    context.go("/analysisParameter");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// 
// #133c55, #9ea3b0, #6b654b, #fc9f5b, #33ca7f

