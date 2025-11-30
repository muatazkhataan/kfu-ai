import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/api/api_manager.dart';
import '../datasources/folder_remote_data_source.dart';
import '../datasources/folder_remote_data_source_impl.dart';
import '../datasources/folder_local_data_source.dart';
import '../datasources/folder_local_data_source_impl.dart';
import '../repositories/folder_repository_impl.dart';
import '../../domain/repositories/folder_repository.dart';

/// Provider لمصدر البيانات البعيدة
final folderRemoteDataSourceProvider =
    Provider<FolderRemoteDataSource>((ref) {
  return FolderRemoteDataSourceImpl(
    apiService: ApiManager().folder,
  );
});

/// Provider لمصدر البيانات المحلية
final folderLocalDataSourceProvider =
    Provider<FolderLocalDataSource>((ref) {
  return FolderLocalDataSourceImpl();
});

/// Provider لمستودع المجلدات
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  return FolderRepositoryImpl(
    remoteDataSource: ref.watch(folderRemoteDataSourceProvider),
    localDataSource: ref.watch(folderLocalDataSourceProvider),
  );
});

