import '../models/models.dart';
import 'data_source.dart';

class Repository {
  final DataSource _dataSource;

  Repository(this._dataSource);

  Future<List<AccountBook>> getAccountBooks() => _dataSource.getAccountBooks();

  Future<AccountBook> createAccountBook(AccountBook book) =>
      _dataSource.createAccountBook(book);

  // 其他方法...
}
