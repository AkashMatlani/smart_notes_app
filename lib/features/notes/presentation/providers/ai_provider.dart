import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/ai_service.dart';

final aiSummaryProvider = FutureProvider.family<String, String>((ref, noteText) async {
  return await AIService().generateSummary(noteText);
});