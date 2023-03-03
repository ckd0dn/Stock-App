import 'package:practice/data/csv/company_listings_parser.dart';
import 'package:practice/data/csv/intraday_info_parser.dart';
import 'package:practice/data/mapper/company_mapper.dart';
import 'package:practice/data/source/local/stock_dao.dart';
import 'package:practice/data/source/remote/stock_api.dart';
import 'package:practice/domain/model/company_info.dart';
import 'package:practice/domain/model/company_listing.dart';
import 'package:practice/domain/model/intraday_info.dart';
import 'package:practice/domain/repository/stock_repository.dart';
import 'package:practice/util/result.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi _api;
  final StockDao _dao;
  final _companyListingsParser = CompanyListingsParser();
  final _IntradayInfoParser = IntradayInfoParser();


  StockRepositoryImpl(this._api, this._dao);

  @override
  Future<Result<List<CompanyListing>>> getCompanyListings(bool fetchFromRemote, String query) async {
    // 캐시에서 찾는다
    final localListings = await _dao.searchCompanyListing(query);

    // 없다면 리모트에서 가져온다
    final isDbEmpty = localListings.isEmpty && query.isEmpty;
    final shouldJustLoadFromCache = !isDbEmpty && !fetchFromRemote;

    if(shouldJustLoadFromCache) {
      return Result.success(
          localListings.map((e) => e.toCompanyListing()).toList());
    }

    //리모트
    try{
      final response  = await _api.getListings();
      final remoteListings = await _companyListingsParser.parse(response.body);

      //캐시 비우기
      await _dao.clearCompanyListings();

      //캐시 추가
      await _dao.insertCompanyListings(
          remoteListings.map((e) => e.toCompanyListingEntity()).toList());

      return Result.success(remoteListings);

    }catch (e) {
      return Result.error(Exception('데이터로드실패'));
    }

  }

  @override
  Future<Result<CompanyInfo>> getCompanyInfo(String symbol) async{

    try {
      final dto = await _api.getCompanyInfo(symbol: symbol);
      return Result.success(dto.toCompanyInfo());
    }catch (e) {
      return Result.error(Exception('회사정보 로드 실패!! : ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<IntradayInfo>>> getIntradayInfo(String symbol) async {
    try {
      final response = await _api.getIntradayInfo(symbol: symbol);
      final result = await _IntradayInfoParser.parse(response.body);
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('intraday 정보 로드 실패 !! : ${e.toString()}'));
    }
  }
  

}