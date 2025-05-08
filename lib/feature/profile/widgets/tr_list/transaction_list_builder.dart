import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'package:stream_challenge/providers/transactions_provider.dart';

import 'transaction_view_widget.dart';

class TransactionsListWidget extends ConsumerStatefulWidget {
  final FutureProviderFamily<List<Transaction>?, GetStruct> trProvider = transactionsProvider;

  TransactionsListWidget({super.key});

  @override
  ConsumerState<TransactionsListWidget> createState() => _TransactionsListState();
}

class _TransactionsListState extends ConsumerState<TransactionsListWidget> {
  bool isRefreshing = false;
  static const int _pageSize = 10;
  final PagingController<int, Transaction> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final getStruct = GetStruct(page: pageKey, size: _pageSize);
      final transactionList = await ref.read(widget.trProvider(getStruct).future);

      if (transactionList == null || transactionList.length < _pageSize) {
        _pagingController.appendLastPage(transactionList ?? []);
      } else {
        final nextPageKey = pageKey + transactionList.length;
        _pagingController.appendPage(transactionList, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRefreshing = false;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 700),
      child: RefreshIndicator(
        onRefresh: () async {
          isRefreshing = true;
          _pagingController.refresh();
        },
        child: PagedListView<int, Transaction>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Transaction>(
            animateTransitions: true,
            itemBuilder: (context, transaction, index) => TransactionViewWidget(transaction: transaction),
            firstPageProgressIndicatorBuilder: (context) => Center(
              child: !isRefreshing ? CircularProgressIndicator() : Text(""),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorWidget(_pagingController.error!),
            newPageErrorIndicatorBuilder: (context) => ErrorWidget(_pagingController.error!),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text(mNoTrans),
            ),
          ),
        ),
      ),
    );
  }
}
