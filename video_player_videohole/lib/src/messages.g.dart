// Autogenerated from Pigeon (v10.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

class PlayerMessage {
  PlayerMessage({
    required this.playerId,
  });

  int playerId;

  Object encode() {
    return <Object?>[
      playerId,
    ];
  }

  static PlayerMessage decode(Object result) {
    result as List<Object?>;
    return PlayerMessage(
      playerId: result[0]! as int,
    );
  }
}

class LoopingMessage {
  LoopingMessage({
    required this.playerId,
    required this.isLooping,
  });

  int playerId;

  bool isLooping;

  Object encode() {
    return <Object?>[
      playerId,
      isLooping,
    ];
  }

  static LoopingMessage decode(Object result) {
    result as List<Object?>;
    return LoopingMessage(
      playerId: result[0]! as int,
      isLooping: result[1]! as bool,
    );
  }
}

class VolumeMessage {
  VolumeMessage({
    required this.playerId,
    required this.volume,
  });

  int playerId;

  double volume;

  Object encode() {
    return <Object?>[
      playerId,
      volume,
    ];
  }

  static VolumeMessage decode(Object result) {
    result as List<Object?>;
    return VolumeMessage(
      playerId: result[0]! as int,
      volume: result[1]! as double,
    );
  }
}

class PlaybackSpeedMessage {
  PlaybackSpeedMessage({
    required this.playerId,
    required this.speed,
  });

  int playerId;

  double speed;

  Object encode() {
    return <Object?>[
      playerId,
      speed,
    ];
  }

  static PlaybackSpeedMessage decode(Object result) {
    result as List<Object?>;
    return PlaybackSpeedMessage(
      playerId: result[0]! as int,
      speed: result[1]! as double,
    );
  }
}

class PositionMessage {
  PositionMessage({
    required this.playerId,
    required this.position,
  });

  int playerId;

  int position;

  Object encode() {
    return <Object?>[
      playerId,
      position,
    ];
  }

  static PositionMessage decode(Object result) {
    result as List<Object?>;
    return PositionMessage(
      playerId: result[0]! as int,
      position: result[1]! as int,
    );
  }
}

class CreateMessage {
  CreateMessage({
    this.asset,
    this.uri,
    this.packageName,
    this.formatHint,
    this.httpHeaders,
    this.drmConfigs,
  });

  String? asset;

  String? uri;

  String? packageName;

  String? formatHint;

  Map<Object?, Object?>? httpHeaders;

  Map<Object?, Object?>? drmConfigs;

  Object encode() {
    return <Object?>[
      asset,
      uri,
      packageName,
      formatHint,
      httpHeaders,
      drmConfigs,
    ];
  }

  static CreateMessage decode(Object result) {
    result as List<Object?>;
    return CreateMessage(
      asset: result[0] as String?,
      uri: result[1] as String?,
      packageName: result[2] as String?,
      formatHint: result[3] as String?,
      httpHeaders:
          (result[4] as Map<Object?, Object?>?)?.cast<Object?, Object?>(),
      drmConfigs:
          (result[5] as Map<Object?, Object?>?)?.cast<Object?, Object?>(),
    );
  }
}

class MixWithOthersMessage {
  MixWithOthersMessage({
    required this.mixWithOthers,
  });

  bool mixWithOthers;

  Object encode() {
    return <Object?>[
      mixWithOthers,
    ];
  }

  static MixWithOthersMessage decode(Object result) {
    result as List<Object?>;
    return MixWithOthersMessage(
      mixWithOthers: result[0]! as bool,
    );
  }
}

class GeometryMessage {
  GeometryMessage({
    required this.playerId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  int playerId;

  int x;

  int y;

  int width;

  int height;

  Object encode() {
    return <Object?>[
      playerId,
      x,
      y,
      width,
      height,
    ];
  }

  static GeometryMessage decode(Object result) {
    result as List<Object?>;
    return GeometryMessage(
      playerId: result[0]! as int,
      x: result[1]! as int,
      y: result[2]! as int,
      width: result[3]! as int,
      height: result[4]! as int,
    );
  }
}

class _VideoPlayerVideoholeApiCodec extends StandardMessageCodec {
  const _VideoPlayerVideoholeApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CreateMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is GeometryMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is LoopingMessage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is MixWithOthersMessage) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackSpeedMessage) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is PlayerMessage) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is PositionMessage) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is VolumeMessage) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CreateMessage.decode(readValue(buffer)!);
      case 129:
        return GeometryMessage.decode(readValue(buffer)!);
      case 130:
        return LoopingMessage.decode(readValue(buffer)!);
      case 131:
        return MixWithOthersMessage.decode(readValue(buffer)!);
      case 132:
        return PlaybackSpeedMessage.decode(readValue(buffer)!);
      case 133:
        return PlayerMessage.decode(readValue(buffer)!);
      case 134:
        return PositionMessage.decode(readValue(buffer)!);
      case 135:
        return VolumeMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class VideoPlayerVideoholeApi {
  /// Constructor for [VideoPlayerVideoholeApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  VideoPlayerVideoholeApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _VideoPlayerVideoholeApiCodec();

  Future<void> initialize() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.initialize', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<PlayerMessage> create(CreateMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.create', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as PlayerMessage?)!;
    }
  }

  Future<void> dispose(PlayerMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.dispose', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setLooping(LoopingMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.setLooping', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setVolume(VolumeMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.setVolume', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setPlaybackSpeed(PlaybackSpeedMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.setPlaybackSpeed', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> play(PlayerMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.play', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<PositionMessage> position(PlayerMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.position', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as PositionMessage?)!;
    }
  }

  Future<void> seekTo(PositionMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.seekTo', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> pause(PlayerMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.pause', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setMixWithOthers(MixWithOthersMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.setMixWithOthers', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setDisplayGeometry(GeometryMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.VideoPlayerVideoholeApi.setDisplayGeometry', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_msg]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }
}
