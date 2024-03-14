import 'dart:convert';

class RechargeDto {
  String status;
  // DateTime date;
  String url;

  RechargeDto({
    required this.status,
    // required this.date,
    required this.url,
  });

  factory RechargeDto.fromJson(Map<String, dynamic> json) {
    return RechargeDto(
      status: json['status'],
      // message: json['message'],
      // date: DateTime.parse(json['date']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      // 'date': date.toIso8601String(),
      'url': url,
    };
  }

  @override
  String toString() {
    return 'RechargeStatus{status: $status, url: $url}';
  }
}
