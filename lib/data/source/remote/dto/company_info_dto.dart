import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_info_dto.freezed.dart';
part 'company_info_dto.g.dart';

@freezed
class CompanyInfoDTO with _$CompanyInfoDTO {
  const factory CompanyInfoDTO({
     @JsonKey(name: 'Symbol') String? symbol,
     @JsonKey(name: 'description') String? description,
     @JsonKey(name: 'Name') String? name,
     @JsonKey(name: 'Country') String? country,
     @JsonKey(name: 'Industry') String? industry,
  }) = _CompanyInfoDTO;
  
  factory CompanyInfoDTO.fromJson(Map<String, Object?> json) => _$CompanyInfoDTOFromJson(json);
}