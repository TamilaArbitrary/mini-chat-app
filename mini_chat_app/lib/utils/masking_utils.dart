String maskEmail(String email) {
  if (email.isEmpty || !email.contains('@')) return '';

  final parts = email.split('@');
  final username = parts[0];
  final domain = '@${parts[1]}';

  if (username.length <= 1) return '*$domain';

  final firstChar = username[0];
  final maskedPart = '*' * (username.length - 1);
  
  return '$firstChar$maskedPart$domain';
}

String maskPhone(String phone) {
  if (phone.length != 10) return '+380 ХХХ ХХ ХХ ХХ';

  final code = phone.substring(0, 3);
  final lastTwo = phone.substring(8, 10);

  return '+38 $code *** ** $lastTwo'; 
}