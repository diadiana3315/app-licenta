import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer
import 'package:audioplayers/audioplayers.dart';

class MetronomeScreen extends StatefulWidget {
  @override
  _MetronomeScreenState createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _metronomeTimer;
  int _tempo = 120; // Default tempo
  int _timeSignature = 4; // Default time signature
  bool _emphasizeFirstBeat = true;
  int _currentBeat = 1;

  @override
  void dispose() {
    _stopMetronome();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startMetronome() {
    _stopMetronome(); // Stop any existing timer
    final interval = Duration(milliseconds: (60000 / _tempo).round());
    _metronomeTimer = Timer.periodic(interval, (Timer timer) {
      _playBeat();
      setState(() {
        _currentBeat = (_currentBeat % _timeSignature) + 1;
      });
    });
  }

  void _stopMetronome() {
    _metronomeTimer?.cancel();
  }

  void _playBeat() {
    try {
      if (_emphasizeFirstBeat && _currentBeat == 1) {
        _audioPlayer.play(AssetSource('sounds/MetronomeSound.mp3')); // First beat sound
      } else {
        _audioPlayer.play(AssetSource('sounds/MetronomeSound.mp3')); // Regular beat sound
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateTempo(int newTempo) {
    setState(() {
      _tempo = newTempo;
      _startMetronome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Metronome')),
      body: Column(
        children: [
          Row(
            children: [
              Text('Tempo: $_tempo BPM'),
              Expanded(
                child: Slider(
                  value: _tempo.toDouble(),
                  min: 40,
                  max: 240,
                  onChanged: (value) {
                    _updateTempo(value.toInt());
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (_tempo > 40) _updateTempo(_tempo - 1);
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_tempo < 240) _updateTempo(_tempo + 1);
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Time Signature:'),
              DropdownButton<int>(
                value: _timeSignature,
                items: [2, 3, 4, 5, 6, 7, 8]
                    .map((value) => DropdownMenuItem(
                  child: Text('$value/4'),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _timeSignature = value!;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _emphasizeFirstBeat,
                onChanged: (value) {
                  setState(() {
                    _emphasizeFirstBeat = value!;
                  });
                },
              ),
              Text('Emphasize First Beat'),
            ],
          ),
          ElevatedButton(
            onPressed: _startMetronome,
            child: Text('Start'),
          ),
          ElevatedButton(
            onPressed: _stopMetronome,
            child: Text('Stop'),
          ),
        ],
      ),
    );
  }
}




