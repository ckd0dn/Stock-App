import 'package:flutter/material.dart';
import 'package:practice/domain/model/company_info.dart';
import 'package:practice/presentation/company_info/company_info_state.dart';
import 'package:practice/presentation/company_info/company_info_view_model.dart';
import 'package:practice/presentation/company_info/components/stock_chart.dart';
import 'package:provider/provider.dart%20';

class CompanyInfoScreen extends StatelessWidget {
  const CompanyInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompanyInfoViewModel>();
    final state = viewModel.state;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (state.errorMessage != null)
              Center(
                child: Text(state.errorMessage!),
              ),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (state.isLoading == false && state.errorMessage == null)
              _buildBody(context, state)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context,CompanyInfoState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.companyInfo!.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            state.companyInfo!.symbol,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const Divider(),
          Text(
            'Industry: ${state.companyInfo!.industry}',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          Text(
            'country: ${state.companyInfo!.country}',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          const Divider(),
          Text(
            state.companyInfo!.description,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 32,),
          const Text(
            '주가 그래프',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if(state.stockInfos.isNotEmpty) StockChart(infos: state.stockInfos, color: Theme.of(context).colorScheme.primary,)
        ],
      ),
    );
  }
}
