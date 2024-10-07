import 'package:html/parser.dart' as html_parser;

class Plan {
  final int id;
  final int groupId;
  final double transferEnable; // En GB
  final String name;
  final int? deviceLimit;
  final int? speedLimit;
  final bool show;
  final int? sort;
  final bool renew;
  final String? content;
  final double? monthPrice;
  final double? quarterPrice;
  final double? halfYearPrice;
  final double? yearPrice;
  final double? twoYearPrice;
  final double? threeYearPrice;
  final double? onetimePrice;
  final double? resetPrice;
  final int? resetTrafficMethod;
  final int? capacityLimit;
  final int createdAt;
  final int updatedAt;

  Plan({
    required this.id,
    required this.groupId,
    required this.transferEnable,
    required this.name,
    this.deviceLimit,
    this.speedLimit,
    required this.show,
    this.sort,
    required this.renew,
    this.content,
    required this.monthPrice,
    this.quarterPrice,
    this.halfYearPrice,
    this.yearPrice,
    this.twoYearPrice,
    this.threeYearPrice,
    this.onetimePrice,
    this.resetPrice,
    this.resetTrafficMethod,
    this.capacityLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    // Limpiar etiquetas HTML
    final rawContent = json['content'] ?? '';
    final document = html_parser.parse(rawContent);
    final cleanContent = document.body?.text ?? '';

    return Plan(
      id: json['id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      transferEnable: (json['transfer_enable'] as num?)?.toDouble() ?? 0.0, // Verificar si transfer_enable es null
      name: json['name'] ?? 'Desconocido',
      deviceLimit: json['device_limit'], // device_limit puede ser null
      speedLimit: json['speed_limit'], // speed_limit puede ser null
      show: json['show'] == 1, // show es verdadero si es 1
      sort: json['sort'], // sort puede ser null
      renew: json['renew'] == 1, // renew es verdadero si es 1
      content: cleanContent.isNotEmpty ? cleanContent : null, // Limpiar el contenido HTML
      monthPrice: json['month_price'] != null
          ? (json['month_price'] as num).toDouble() / 100
          : null, // Verificar si quarter_price es null antes de convertir
      quarterPrice: json['quarter_price'] != null
          ? (json['quarter_price'] as num).toDouble() / 100
          : null, // Verificar si quarter_price es null antes de convertir
      halfYearPrice: json['half_year_price'] != null
          ? (json['half_year_price'] as num).toDouble() / 100
          : null, // Verificar si half_year_price es null
      yearPrice: json['year_price'] != null
          ? (json['year_price'] as num).toDouble() / 100
          : null, // Verificar si year_price es null
      twoYearPrice: json['two_year_price'] != null
          ? (json['two_year_price'] as num).toDouble() / 100
          : null, // Verificar si two_year_price es null
      threeYearPrice: json['three_year_price'] != null
          ? (json['three_year_price'] as num).toDouble() / 100
          : null, // Verificar si three_year_price es null
      onetimePrice: json['onetime_price'] != null
          ? (json['onetime_price'] as num).toDouble() / 100
          : null, // Verificar si onetime_price es null
      resetPrice: json['reset_price'] != null
          ? (json['reset_price'] as num).toDouble() / 100
          : null, // Verificar si reset_price es null
      resetTrafficMethod: json['reset_traffic_method'], // reset_traffic_method puede ser null
      capacityLimit: json['capacity_limit'], // capacity_limit puede ser null
      createdAt: json['created_at'] ?? 0, // Manejo de created_at con valor por defecto 0
      updatedAt: json['updated_at'] ?? 0, // Manejo de updated_at con valor por defecto 0
    );
  }
}
