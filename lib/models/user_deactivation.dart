class UserDeactivation {
  final String reason;
  final bool isActive;

  UserDeactivation({
    required this.reason,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'is_active': isActive,
    };
  }
} 