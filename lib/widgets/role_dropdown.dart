import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: ['admin', 'manager', 'cashier']
          .map((role) => DropdownMenuItem(
                value: role,
                child: Text(
                  role == 'admin' ? 'Administrateur' 
                  : role == 'manager' ? 'Manager' 
                  : 'Caissier',
                ),
              ))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Rôle',
        border: OutlineInputBorder(),
      ),
    );
  }
}