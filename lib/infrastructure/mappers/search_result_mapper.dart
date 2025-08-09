import '../../domain/entities/search_result.dart';
import '../dto/search_result_dto.dart';

class SearchResultMapper {
  SearchResult fromDto(SearchResultDto dto) {
    final dateParts = dto.date.split('-').map(int.parse).toList();
    final timeParts = dto.time.split(':').map(int.parse).toList();
    final dateTime = DateTime(
      dateParts[0],
      dateParts[1],
      dateParts[2],
      timeParts[0],
      timeParts[1],
    );
    return SearchResult(
      airline: dto.airline,
      from: dto.from,
      to: dto.to,
      seat: dto.seat,
      dateTime: dateTime,
    );
  }
}
