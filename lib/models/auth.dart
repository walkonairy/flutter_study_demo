import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class Auth {
    Auth();

    num userId;
    String token;
    
    factory Auth.fromJson(Map<String,dynamic> json) => _$AuthFromJson(json);
    Map<String, dynamic> toJson() => _$AuthToJson(this);
}
