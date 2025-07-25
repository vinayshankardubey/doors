import 'dart:io';

/// Entry point of the script
/// It ensures the `.env.example` file exists, generates other `.env` files,
/// and updates the `pubspec.yaml` with the provided project name and version.
void main() {
  generateEnvExampleIfMissing();
  generateEnvFiles();
  updatePubspec(projectName: 'prototype', version: '1.0.0+1');
}

/// Ensures that `.env.example` exists.
/// If not, it creates a new `.env.example` with default values.
void generateEnvExampleIfMissing() {
  final exampleFile = File('.env.example');

  // Create the file with default content if it doesn't exist
  if (!exampleFile.existsSync()) {
    exampleFile.writeAsStringSync(
      'API_URL=https://api.example.com\nAPP_NAME=My Flutter App',
    );
    print('🆕 .env.example created with default content');
  } else {
    print('✅ .env.example already exists');
  }
}

/// Generates `.env.dev`, `.env.staging`, and `.env.production`
/// by copying the content from `.env.example`.
void generateEnvFiles() {
  final example = File('.env.example').readAsStringSync();

  // Loop through desired environments and generate files
  for (var env in ['dev', 'staging', 'prod']) {
    final file = File('.env.$env');
    file.writeAsStringSync(example);
    print('.env.$env created');
  }
}

/// Updates the `pubspec.yaml` file with a given project name and version.
/// If `name:` or `version:` are not found, they are added at the top.
void updatePubspec({required String projectName, required String version}) {
  final pubspec = File('pubspec.yaml');

  // Ensure pubspec.yaml exists
  if (!pubspec.existsSync()) {
    print('❌ pubspec.yaml not found!');
    return;
  }

  // Read lines from pubspec.yaml
  List<String> lines = pubspec.readAsLinesSync();
  bool nameUpdated = false;
  bool versionUpdated = false;

  // Update lines if name/version exist
  final updatedLines = lines.map((line) {
    if (line.startsWith('name:')) {
      nameUpdated = true;
      return 'name: $projectName';
    } else if (line.startsWith('version:')) {
      versionUpdated = true;
      return 'version: $version';
    }
    return line;
  }).toList();

  // Insert name/version if they weren’t found
  if (!nameUpdated) updatedLines.insert(0, 'name: $projectName');
  if (!versionUpdated) updatedLines.insert(1, 'version: $version');

  // Write changes back to pubspec.yaml
  pubspec.writeAsStringSync(updatedLines.join('\n'));

  print('✅ pubspec.yaml updated with name "$projectName" and version "$version"');
}
