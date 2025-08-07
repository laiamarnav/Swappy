enum ExchangeRequestStatus { pending, accepted, rejected }

class ExchangeRequest {
  final String id;
  final String listingId;
  final String fromUserId;
  final String toUserId;
  ExchangeRequestStatus status;

  ExchangeRequest({
    required this.id,
    required this.listingId,
    required this.fromUserId,
    required this.toUserId,
    this.status = ExchangeRequestStatus.pending,
  });
}
