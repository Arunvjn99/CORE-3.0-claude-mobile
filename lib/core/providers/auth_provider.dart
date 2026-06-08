import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

// ── Demo mode flag ─────────────────────────────────────────────────────────
// When true, the user is treated as authenticated without a real Supabase session.
final demoModeProvider = StateProvider<bool>((ref) => false);

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateProvider); // Re-evaluate whenever auth state changes
  return ref.watch(supabaseProvider).auth.currentUser;
});

// isAuthenticated = real Supabase session OR demo mode
final isAuthenticatedProvider = Provider<bool>((ref) {
  if (ref.watch(demoModeProvider)) return true;
  return ref.watch(currentUserProvider) != null;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(supabaseProvider), ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;
  final Ref _ref;

  AuthNotifier(this._client, this._ref) : super(const AsyncValue.data(null));

  /// Sign in with email + password. Returns null on success, error string on failure.
  Future<String?> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth
          .signInWithPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15));
      state = const AsyncValue.data(null);
      return null;
    } on AuthException catch (e) {
      state = const AsyncValue.data(null);
      return e.message;
    } catch (e) {
      state = const AsyncValue.data(null);
      final msg = e.toString();
      if (msg.contains('SocketException') ||
          msg.contains('ClientException') ||
          msg.contains('Failed host') ||
          msg.contains('TimeoutException') ||
          msg.contains('NetworkException') ||
          msg.contains('No address')) {
        return 'Cannot connect to server. Tap "Explore Demo Mode" to try the app offline.';
      }
      return 'Sign in failed. Please try again.';
    }
  }

  Future<String?> signUp(
      String email, String password, String fullName) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth
          .signUp(email: email, password: password, data: {'full_name': fullName})
          .timeout(const Duration(seconds: 15));
      state = const AsyncValue.data(null);
      return null;
    } on AuthException catch (e) {
      state = const AsyncValue.data(null);
      return e.message;
    } catch (e) {
      state = const AsyncValue.data(null);
      final msg = e.toString();
      if (msg.contains('SocketException') ||
          msg.contains('ClientException') ||
          msg.contains('Failed host') ||
          msg.contains('TimeoutException') ||
          msg.contains('No address')) {
        return 'Cannot connect to server. Tap "Explore Demo Mode" to try the app offline.';
      }
      return 'Sign up failed. Please try again.';
    }
  }

  Future<String?> sendOtp(String email) async {
    try {
      await _client.auth
          .signInWithOtp(email: email)
          .timeout(const Duration(seconds: 15));
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Failed to send code';
    }
  }

  Future<String?> verifyOtp(String email, String token) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth
          .verifyOTP(email: email, token: token, type: OtpType.email)
          .timeout(const Duration(seconds: 15));
      state = const AsyncValue.data(null);
      return null;
    } on AuthException catch (e) {
      state = const AsyncValue.data(null);
      return e.message;
    } catch (e) {
      state = const AsyncValue.data(null);
      return 'Verification failed';
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _client.auth
          .resetPasswordForEmail(email)
          .timeout(const Duration(seconds: 15));
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Failed to send reset email';
    }
  }

  Future<void> signOut() async {
    _ref.read(demoModeProvider.notifier).state = false;
    try {
      await _client.auth.signOut();
    } catch (_) {}
  }

  /// Activate demo mode — bypasses all Supabase auth
  void signInDemo() {
    _ref.read(demoModeProvider.notifier).state = true;
    state = const AsyncValue.data(null);
  }
}

// User profile provider
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final isDemoMode = ref.watch(demoModeProvider);
  if (isDemoMode) {
    return UserProfile(
      id: 'demo-user',
      email: 'demo@congruentsolutions.com',
      firstName: 'Alex',
      lastName: 'Johnson',
    );
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final client = ref.watch(supabaseProvider);
  try {
    final data = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (data == null) {
      return UserProfile(
        id: user.id,
        email: user.email ?? '',
        firstName: user.userMetadata?['full_name']
            ?.toString()
            .split(' ')
            .firstOrNull,
        lastName: user.userMetadata?['full_name']
            ?.toString()
            .split(' ')
            .lastOrNull,
      );
    }
    return UserProfile.fromJson({...data, 'email': user.email ?? ''});
  } catch (_) {
    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      firstName: user.userMetadata?['full_name']
          ?.toString()
          .split(' ')
          .firstOrNull,
    );
  }
});
