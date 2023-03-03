import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:practice/domain/repository/stock_repository.dart';
import 'package:practice/presentation/company_listings/company_listings_state.dart';

import 'company_listings_action.dart';

class CompanyListingsViewModel with ChangeNotifier {
  final StockRepository _repository;

  var _state = const CompanyListingsState();

  Timer? _debounce;

  get state => _state;

  CompanyListingsViewModel(this._repository) {
    _getCompanyListings();
  }

  void onAction(CompanyListingsAction action) {
    action.when(
        refresh: () => _getCompanyListings(fetchFromRemote: true),
        onSearchQueryChange: (query) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _getCompanyListings(query: query);
          });
        });
  }

  Future _getCompanyListings({
    bool fetchFromRemote = false,
    String query = '',
  }) async {
    _state = state.copyWith(
      isLoading: true,
    );
    notifyListeners();

    final result = await _repository.getCompanyListings(fetchFromRemote, query);

    result.when(success: (listings) {
      _state = state.copyWith(
        companies: listings,
      );
    }, error: (e) {
      //TODO 에러처리
      if (kDebugMode) {
        print('리모트에러 : $e');
      }
    });

    _state = state.copyWith(
      isLoading: false,
    );

    notifyListeners();
  }
}
