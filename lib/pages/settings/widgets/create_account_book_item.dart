import 'package:flutter/material.dart';
import '../../../services/data_service.dart';

class CreateAccountBookItem extends StatelessWidget {
  final DataService _dataService;

  const CreateAccountBookItem({
    Key? key,
    required DataService dataService,
  }) : _dataService = dataService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.book),
      title: Text('账本管理'),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, '/account-books').then((_) {
          _dataService.fetchAccountBooks(forceRefresh: true);
        });
      },
    );
  }
} 