import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile_model.dart';

class CurrentUserNotifier extends Notifier<UserProfileModel> {
  final List<UserProfileModel> availableProfiles = const [
    UserProfileModel(
      id: 'user_me',
      name: 'Иван (Клиент)',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    ),
    UserProfileModel(
      id: 'trainer',
      name: 'Александр (Тренер)',
      avatarUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=200&auto=format&fit=crop',
      isTrainer: true,
    ),
    UserProfileModel(
      id: 'nutritionist',
      name: 'Ольга (Нутрициолог)',
      avatarUrl: 'https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200&auto=format&fit=crop',
      isTrainer: true,
    ),
  ];

  @override
  UserProfileModel build() {
    return availableProfiles[0];
  }

  void switchProfile(String id) {
    state = availableProfiles.firstWhere((profile) => profile.id == id);
  }

  final StateProvider<List<UserProfileModel>> profilesListProvider = StateProvider((ref) => []);
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserProfileModel>(CurrentUserNotifier.new);