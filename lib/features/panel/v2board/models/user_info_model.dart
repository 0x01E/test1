import 'dart:ffi';

class UserInfo {
  final String email;
  final int transferEnable;
  final int? deviceLimit;
  final int? lastLoginAt;
  final int createdAt;
  final int banned; // 0: No está baneado, 1: Baneado
  final int remindExpire;
  final int remindTraffic;
  final int? expiredAt;
  final double balance; // Balance como número con decimales
  final double commissionBalance; // Comisión restante como número decimal
  final int planId;
  final double? discount;
  final double? commissionRate;
  final int? telegramId;
  final String uuid;
  final String avatarUrl;

  UserInfo({
    required this.email,
    required this.transferEnable,
    this.deviceLimit,
    this.lastLoginAt,
    required this.createdAt,
    required this.banned,
    required this.remindExpire,
    required this.remindTraffic,
    this.expiredAt,
    required this.balance,
    required this.commissionBalance,
    required this.planId,
    this.discount,
    this.commissionRate,
    this.telegramId,
    required this.uuid,
    required this.avatarUrl,
  });

  // Creación de instancia desde JSON
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      transferEnable: json['transfer_enable'],
      deviceLimit: json['device_limit'],
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'],
      banned: json['banned'],
      remindExpire: json['remind_expire'],
      remindTraffic: json['remind_traffic'],
      expiredAt: json['expired_at'],
      balance: (json['balance'] as num).toDouble(), // Convierte a double
      commissionBalance: (json['commission_balance'] as num).toDouble(), // Convierte a double
      planId: json['plan_id'],
      discount: json['discount'] != null ? (json['discount'] as num).toDouble() : null,
      commissionRate: json['commission_rate'] != null ? (json['commission_rate'] as num).toDouble() : null,
      telegramId: json['telegram_id'],
      uuid: json['uuid'],
      avatarUrl: json['avatar_url'],
    );
  }
}

