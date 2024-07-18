import 'dart:async';
import 'dart:io';

import 'package:bfootlearn/notifications/showPermissionDeniedDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<void> init({required BuildContext context}) async {
    debugPrint('init started');

    try {
      final microphonePermissionStatus = await Permission.microphone.request();
      if (microphonePermissionStatus.isGranted) {
        final manageExternalStorageStatus =
            await Permission.manageExternalStorage.request();
        if (manageExternalStorageStatus.isDenied ||
            manageExternalStorageStatus.isPermanentlyDenied ||
            manageExternalStorageStatus.isRestricted) {
          final storagePermissionStatus = await Permission.storage.request();
          if (storagePermissionStatus.isDenied ||
              storagePermissionStatus.isPermanentlyDenied) {
            debugPrint('Storage Permission Denied');
            Navigator.of(context).pop();
            showPermissionDeniedDialog(
              context: context,
              content:
                  'Storage permission is required to add or update conversations. Please enable it in the app settings.',
            );
            return;
          }
        }
      } else if (microphonePermissionStatus.isDenied ||
          microphonePermissionStatus.isPermanentlyDenied) {
        debugPrint('Microphone Permission Denied');
        Navigator.of(context).pop();
        showPermissionDeniedDialog(
          context: context,
          content:
              'Audio permission is required to add or update conversations. Please enable it in the app settings.',
        );
        return;
      }

      final directory = await getExternalStorageDirectory();
      pathToSaveAudio = '${directory?.path}/picked_audio_recording.aac';
      debugPrint('pathToSave $pathToSaveAudio');
    } catch (e) {
      debugPrint('Error initializing FlutterSoundMethods: $e');
      rethrow;
    }
  }

  void dispose() {
    _isRecorderInitialised = false;
    _isPlayerInitialised = false;
    _audioRecorder.deleteRecord(fileName: pathToSaveAudio);
  }

  Future<String> getPathToSave({required BuildContext context}) async {
    if (pathToSaveAudio == '') {
      await init(context: context);
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
