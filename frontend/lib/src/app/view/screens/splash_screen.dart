import 'package:flutter/material.dart';
import 'package:frontend/src/app/view/screens/stepper_screen.dart';
import 'package:frontend/src/utils/routes/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation _animation;

  // @override
  // void initState() {
  //   super.initState();

  //   _controller = AnimationController(vsync: this, duration: Duration(seconds: 3),);
  //   _animation =

  // }

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
                  Navigator.of(context).pushNamed(RouteManager.dashboardView);
                },
                style: ElevatedButton.styleFrom(
                  // fixedSize: Size(MediaQuery.sizeOf(context).width * 0.2,
                  //     MediaQuery.sizeOf(context).height * 0.05),
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.forward_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Continue")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
