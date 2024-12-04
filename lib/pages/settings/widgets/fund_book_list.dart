import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../constants/theme_constants.dart';
import './fund_filter_chip.dart';

class FundBookList extends StatelessWidget {
  final List<AccountBook> books;
  final List<FundBook> selectedBooks;
  final ValueChanged<FundBook> onBookSettingsChanged;

  const FundBookList({
    Key? key,
    required this.books,
    required this.selectedBooks,
    required this.onBookSettingsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: books.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: AppDimens.padding,
          endIndent: AppDimens.padding,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          final fundBook = selectedBooks.firstWhere(
            (fb) => fb.accountBookId == book.id,
            orElse: () => FundBook(
              accountBookId: book.id,
              accountBookName: book.name,
            ),
          );

          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimens.padding,
              vertical: 0,
            ),
            minVerticalPadding: 8,
            title: Text(
              book.name,
              style: theme.textTheme.titleSmall,
            ),
            trailing: Wrap(
              spacing: AppDimens.paddingTiny,
              children: [
                FundFilterChip(
                  label: '收入',
                  selected: fundBook.fundIn,
                  onSelected: (value) => onBookSettingsChanged(
                    fundBook.copyWith(fundIn: value),
                  ),
                ),
                FundFilterChip(
                  label: '支出',
                  selected: fundBook.fundOut,
                  onSelected: (value) => onBookSettingsChanged(
                    fundBook.copyWith(fundOut: value),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
