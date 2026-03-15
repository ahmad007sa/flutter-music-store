class Invoice {
  Invoice(
      {required this.date,
      required this.creditCard,
      required this.total,
      required this.customerId,
      required this.inVoiceId});

  final String date;
  final String creditCard;
  final int total;
  final String customerId;
  final String inVoiceId;
}
