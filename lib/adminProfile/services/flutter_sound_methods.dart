import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterSoundMethods {
  String pathToSaveAudio = '';
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isRecorderInitialised = false;
  bool _isPlayerInitialised = false;

  bool get isRecorderInitialised => _isRecorderInitialised;
  bool get isPlayerInitialised => _isPlayerInitialised;
  bool get isRecording => _audioRecorder.isRecording;
  bool get isRecordingStopped => _audioRecorder.isStopped;
  bool get isPlaying => _audioPlayer.isPlaying;
  bool get isPlayingPaused => _audioPlayer.isPaused;

  Future init() async {
    final microphonePermissionStatus = await Permission.microphone.request();
    final storagePermissionStatus = await Permission.storage.request();

    if (microphonePermissionStatus != PermissionStatus.granted ||
        storagePermissionStatus != PermissionStatus.granted) {
      throw RecordingPermissionException(
          'Microphone or Storage permission is not allowed.');
    }
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      pathToSaveAudio = '${directory.path}/picked_audio_recording.aac';
      print('pathToSave $pathToSaveAudio');
    } else {
      throw Exception('Failed to get external storage directory');
    }
  }

  void dispose() {
    _isRecorderInitialised = false;
    _isPlayerInitialised = false;
    _audioRecorder.deleteRecord(fileName: pathToSaveAudio);
  }

  Future<String> getPathToSave() async {
    if (pathToSaveAudio == '') {
      await init();
    }
    return pathToSaveAudio;
  }

  Future startRecording() async {
    await _audioRecorder.openRecorder();
    _isRecorderInitialised = true;
    await _audioRecorder.startRecorder(toFile: pathToSaveAudio);
  }

  Future stopRecording() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder.stopRecorder();
    File audioFile = File(pathToSaveAudio);
    debugPrint('Recording stopped, file exists: ${audioFile.existsSync()}');
  }

  Future startPlaying() async {
    await _audioPlayer.openPlayer();
    _isPlayerInitialised = true;
    await _audioPlayer.startPlayer(
      fromURI: pathToSaveAudio,
      whenFinished: () {
        _audioPlayer.closePlayer();
        _isPlayerInitialised = false;
      },
    );
  }

  Future pausePlaying() async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer.pausePlayer();
  }

  Future resumePlaying() async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer.resumePlayer();
  }
}
