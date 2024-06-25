import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/key.dart';
import 'package:frontend/src/utils/routes/route_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "JF-SOLVER",
              style: TextStyle(
                fontSize: 90,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: ElevatedButton(
                onPressed: () async {
                  ref
                      .watch(isAnalysisCollectorFormValidProvider.notifier)
                      .state = false;
                  Navigator.of(context).pushNamed(RouteManager.dashboardView);
                },
                style: ElevatedButton.styleFrom(
                  // fixedSize: Size(MediaQuery.sizeOf(context).width * 0.2,
                  //     MediaQuery.sizeOf(context).height * 0.05),
                  elevation: 16,
                  shape: const CircleBorder(),
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Icon(Icons.forward_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }
}
