import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';
import '../widgets/async_value_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: AsyncValueWidget(
        value: profile,
        onRetry: () => ref.invalidate(profileProvider),
        data: (user) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  user.fullName.characters.first,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(user.email),
              const SizedBox(height: 24),
              _InfoTile(icon: Icons.phone_outlined, label: user.phone),
              _InfoTile(icon: Icons.location_on_outlined, label: user.address),
              _InfoTile(icon: Icons.location_city_outlined, label: user.city),
              _InfoTile(
                icon: Icons.calendar_month_outlined,
                label:
                    'Membre depuis le ${_formatDate(user.memberSince)}',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Commandes',
                      value: '${user.ordersCount}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Points fidélité',
                      value: '${user.loyaltyPoints}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Compte de démonstration (données mockées).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
