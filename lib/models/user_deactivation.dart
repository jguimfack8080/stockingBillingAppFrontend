class UserDeactivation {
  final String reason;
  final bool isDeactivating;

  UserDeactivation({
    required this.reason,
    this.isDeactivating = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'is_deactivating': isDeactivating,
    };
  }
} 