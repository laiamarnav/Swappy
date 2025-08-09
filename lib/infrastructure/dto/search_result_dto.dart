class SearchResultDto {
  final String airline;
  final String from;
  final String to;
  final String seat;
  final String date; // ISO yyyy-MM-dd
  final String time; // HH:mm

  SearchResultDto({
    required this.airline,
    required this.from,
    required this.to,
    required this.seat,
    required this.date,
    required this.time,
  });
}
