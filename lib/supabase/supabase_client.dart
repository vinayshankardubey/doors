import 'dart:async';
import 'package:doors/supabase/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/routes/app_routes.dart';
import '../core/utils.dart';

class SupabaseManager {
  static final SupabaseClient supabaseClient = Supabase.instance.client;
  static SupabaseClient get client => Supabase.instance.client;
  static bool _isInitialized = false;

  static final StreamController<User?> _authStreamController =
  StreamController<User?>.broadcast();

  static RealtimeChannel? _channel;
  static bool get isUser => supabaseClient.auth.currentUser != null;
  static User? get user => supabaseClient.auth.currentUser;
  static dynamic get getUserName => user?.userMetadata?['name']?.toString().split(" ")[0] ?? "user - ${user?.id ?? ""}";
  static ValueNotifier<bool> musicBroadcastNotifier = ValueNotifier(true);

  static Future<void> initialize(String environment) async {
    if (_isInitialized) return;
    env = environment;
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    initializeAuthListener();
    _isInitialized = true;
  }

  ///This method is used for init realtime
  static void initRealtime() {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return;
    _channel = supabaseClient.channel('user-$userId')
      ..onBroadcast(
        event: 'new-audio',
        callback: (payload) {
          musicBroadcastNotifier.value = true;
          musicBroadcastNotifier.value = false;
          Utils.logD(payload);
        },
      )
      ..subscribe();
    Utils.logD("Channel is Listening");
  }

  void disposeRealtime() {
    _channel?.unsubscribe();
  }

  /// Initialize Auth Listener
  static void initializeAuthListener() {
    supabaseClient.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final User? user = data.session?.user;

      // Broadcast the auth state change to the app
      _authStreamController.add(user);

      // Handle specific auth events
      switch (event) {
        case AuthChangeEvent.signedIn:
          Utils.logD('User signed in: ${user?.email}');
          initRealtime();
          break;
        case AuthChangeEvent.signedOut:
          Utils.logD('User signed out');
          Utils.navigateToOffAll(AppRoutes.loginView); // Example navigation
          break;
        case AuthChangeEvent.tokenRefreshed:
          Utils.logD('User token refreshed');
          break;
        default:
          Utils.logD('Auth event occurred: $event');
      }
    });
    initRealtime();
  }

  ///This method is used for Logout the user
  static Future<bool?> logout(BuildContext context) async {
    bool? confirmLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      try {
        await supabaseClient.auth.signOut();
        return true;
      } catch (e) {
        ///
      }
      return null;
    } else {
      return false;
    }
  }


}