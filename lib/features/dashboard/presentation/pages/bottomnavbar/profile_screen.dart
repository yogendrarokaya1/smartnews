import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final nameController = TextEditingController(text: state.user?.name ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.user == null
          ? const Center(child: Text("No profile data"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: state.user!.avatar != null
                        ? NetworkImage(state.user!.avatar!)
                        : const AssetImage(
                                'assets/images/avatar_placeholder.png',
                              )
                              as ImageProvider,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      hintText: state.user!.email,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(profileProvider.notifier)
                            .updateProfile(
                              name: nameController.text,
                              avatarPath: null,
                            );
                      },
                      child: const Text("Update Profile"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
