import 'package:practice/data/source/local/company_listing_entity.dart';
import 'package:practice/data/source/remote/dto/company_info_dto.dart';
import 'package:practice/domain/model/company_info.dart';
import 'package:practice/domain/model/company_listing.dart';

extension ToCompanyListing on CompanyListingEntity {
  CompanyListing toCompanyListing() {
    return CompanyListing(symbol: symbol, name: name, exchange: exchange);
  }
}

extension ToCompanyListingEntity on CompanyListing {
  CompanyListingEntity toCompanyListingEntity() {
    return CompanyListingEntity(symbol: symbol, name: name, exchange: exchange);
  }
}

extension ToCompanyInfo on CompanyInfoDTO {
  CompanyInfo toCompanyInfo() {
    return CompanyInfo(
      symbol: symbol ?? '',
      description: description ?? '',
      name: name ?? '',
      country: country ?? '',
      industry: industry ?? '',
    );
  }
}
