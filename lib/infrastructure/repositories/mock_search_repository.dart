import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../dto/search_result_dto.dart';
import '../mappers/search_result_mapper.dart';

class MockSearchRepository implements SearchRepository {
  final _mapper = SearchResultMapper();

  final List<SearchResultDto> _data = [
    SearchResultDto(
      airline: 'Air France',
      from: 'Barcelona',
      to: 'Paris',
      seat: '12A',
      date: '2025-11-30',
      time: '10:15',
    ),
    SearchResultDto(
      airline: 'Vueling',
      from: 'Barcelona',
      to: 'Rome',
      seat: '9C',
      date: '2025-11-30',
      time: '12:20',
    ),
    SearchResultDto(
      airline: 'KLM',
      from: 'Berlin',
      to: 'Amsterdam',
      seat: '8B',
      date: '2025-12-01',
      time: '09:45',
    ),
  ];

  @override
  Future<List<SearchResult>> search({
    required String from,
    required String to,
    required String seat,
    required DateTime dateTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: implement filtering using params
    return _data.map(_mapper.fromDto).toList();
  }
}
