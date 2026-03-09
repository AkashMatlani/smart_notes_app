import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  bool _isProcessing = false;
  final Queue<_RequestItem> _requestQueue = Queue<_RequestItem>();

  final _cache = HashMap<String, String>();

  final Dio _dio = Dio();
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  Future<String> generateSummary(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return Future.value('');

    // Return cached summary if available
    if (_cache.containsKey(trimmedText)) {
      return Future.value(_cache[trimmedText]!);
    }

    // Add request to queue
    final completer = Completer<String>();
    _requestQueue.add(_RequestItem(trimmedText, completer));

    // Process queue if not already
    if (!_isProcessing) {
      _processQueue();
    }

    return completer.future;
  }
  /// Internal queue processor
  Future<void> _processQueue() async {
    _isProcessing = true;

    while (_requestQueue.isNotEmpty) {
      final item = _requestQueue.removeFirst();
      try {
        final summary = await _callApiWithRetries(item.text);
        // Cache the result
        _cache[item.text] = summary;
        item.completer.complete(summary);
      } catch (e) {
        item.completer.completeError(e);
      }

      // Small delay between requests to reduce hitting rate limit
      await Future.delayed(const Duration(milliseconds: 200));
    }

    _isProcessing = false;
  }

  /// Call API with exponential backoff for 429
  Future<String> _callApiWithRetries(String text) async {
    int retries = 0;
    const maxRetries = 5;

    while (retries < maxRetries) {
      try {
        final response = await _dio.post(
          'https://api.openai.com/v1/chat/completions',
          data: {
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "system", "content": "You are a helpful assistant."},
              {
                "role": "user",
                "content": "Summarize this note in 1-2 sentences: $text"
              }
            ],
            "max_tokens": 50,
          },
          options: Options(
            headers: {
              "Authorization": "Bearer $apiKey",
              "Content-Type": "application/json",
            },
          ),
        );

        return response.data['choices'][0]['message']['content']
            .toString()
            .trim();
      } on DioError catch (e) {
        if (e.response?.statusCode == 429) {
          retries++;
          final delay = Duration(seconds: 2 * (1 << (retries - 1))); // 2,4,8,16s
          print(
              'Rate limited (429). Retrying in ${delay.inSeconds} seconds... Attempt $retries/$maxRetries');
          await Future.delayed(delay);
        } else {
          rethrow;
        }
      }
    }

    throw Exception('Too many requests. Please try again later.');
  }
}
/// Helper class to store queued requests
class _RequestItem {
  final String text;
  final Completer<String> completer;
  _RequestItem(this.text, this.completer);
}