import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analysisCollectorFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});


final isAnalysisCollectorFormValidProvider = StateProvider<bool>((ref) {
  return false;
});