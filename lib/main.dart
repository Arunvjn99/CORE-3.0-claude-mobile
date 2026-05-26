import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

// Supabase credentials — Core 3.0 Claude project
const _supabaseUrl = 'https://vrivhbghtffppkezvkfg.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyaXZoYmdodGZmcHBrZXp2a2ZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwNjc4MjksImV4cCI6MjA5MTY0MzgyOX0.laLOzOVefmqohCSehxEizzUArAtiJT2H8zw25KgRim8';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(
    const ProviderScope(
      child: ParticipantPortalApp(),
    ),
  );
}
