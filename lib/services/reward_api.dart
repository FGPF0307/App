import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitarena/services/api_config.dart';

/// Model satu item reward dari API.
class RewardItem {
  final String? id;
  final String name; // boleh 2 baris (\n)
  final int cost;
  final String category; // 'voucher' | 'nutrition'

  const RewardItem({
    this.id,
    required this.name,
    required this.cost,
    required this.category,
  });

  String get oneLine => name.replaceAll('\n', ' ');

  factory RewardItem.fromJson(Map<String, dynamic> json) => RewardItem(
        id: json['id'] as String?,
        name: (json['name'] ?? '') as String,
        cost: (json['cost'] as num?)?.toInt() ?? 0,
        category: (json['category'] ?? 'voucher') as String,
      );
}

class RewardApi {
  /// READ — ambil semua reward.
  static Future<List<RewardItem>> fetchRewards() async {
    final res = await http
        .get(Uri.parse('$apiBaseUrl/api/rewards'))
        .timeout(apiTimeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat reward (HTTP ${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['data'] as List)
        .cast<Map<String, dynamic>>()
        .map(RewardItem.fromJson)
        .toList();
  }
}
