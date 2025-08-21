class SearchResult {
  final String airline;
  final String from;
  final String to;
  final String seat;
  final DateTime dateTime;
  final String? flightCode; 

  SearchResult({
    required this.airline,
    required this.from,
    required this.to,
    required this.seat,
    required this.dateTime,
    this.flightCode
  });
}
