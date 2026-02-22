import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/edit_profile_screen.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/profile_state.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/profile_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile when screen opens
    Future.microtask(
      () => ref.read(profileViewModelProvider.notifier).getProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: profileState.status == ProfileStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : profileState.status == ProfileStatus.error
          ? _buildError(profileState.errorMessage)
          : _buildProfile(context, profileState),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message ?? 'Something went wrong'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                ref.read(profileViewModelProvider.notifier).getProfile(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileState state) {
    final user = state.user;
    if (user == null) return const SizedBox.shrink();

    final imageUrl = ApiEndpoints.getImageUrl(user.profilePicture);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl.isEmpty
                        ? Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (user.role != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
                ref.read(profileViewModelProvider.notifier).getProfile();
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Account Info'),
                const SizedBox(height: 12),
                _infoCard(context, [
                  _infoTile(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    value: user.fullName,
                  ),
                  _infoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                  ),
                  _infoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phoneNumber ?? 'Not provided',
                  ),
                ]),
                const SizedBox(height: 24),
                _sectionTitle(context, 'Settings'),
                const SizedBox(height: 12),
                _infoCard(context, [
                  _actionTile(
                    context,
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    ),
                  ),
                  _actionTile(
                    context,
                    icon: Icons.logout,
                    label: 'Logout',
                    color: Colors.red,
                    onTap: () => _confirmLogout(context),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _infoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authViewModelProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
