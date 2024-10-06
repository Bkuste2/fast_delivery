import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
class Address {
  @HiveField(0)
  final String street;

  @HiveField(1)
  final String city;

  Address({required this.street, required this.city});
}
