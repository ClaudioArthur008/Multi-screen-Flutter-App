enum RentalStatus { approved, pending, declined }

class Rental {
  final int id;
  final int userId;
  final String propertyId;
  final RentalStatus status;

  const Rental({
    required this.id,
    required this.userId,
    required this.propertyId,
    this.status = RentalStatus.pending,
  });
}
