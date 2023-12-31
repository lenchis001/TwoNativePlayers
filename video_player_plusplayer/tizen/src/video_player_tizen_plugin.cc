// Copyright 2022 Samsung Electronics Co., Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "video_player_tizen_plugin.h"

#include <app_common.h>
#include <dart_api_dl.h>
#include <flutter/event_channel.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <flutter_tizen.h>

#include <condition_variable>
#include <map>
#include <mutex>

#include "flutter_texture_registrar.h"
#include "log.h"
#include "messages.h"
#include "video_player.h"
#include "video_player_options.h"

namespace {

class VideoPlayerTizenPlugin : public flutter::Plugin, public VideoPlayerApi {
 public:
  static void RegisterWithRegistrar(
      FlutterDesktopPluginRegistrarRef registrar_ref,
      flutter::PluginRegistrar *plugin_registrar);
  VideoPlayerTizenPlugin(FlutterDesktopPluginRegistrarRef registrar_ref,
                         flutter::PluginRegistrar *plugin_registrar);
  virtual ~VideoPlayerTizenPlugin();
  std::optional<FlutterError> Initialize() override;
  ErrorOr<std::unique_ptr<TextureMessage>> Create(
      const CreateMessage &createMsg) override;
  std::optional<FlutterError> Dispose(
      const TextureMessage &textureMsg) override;
  std::optional<FlutterError> SetLooping(
      const LoopingMessage &loopingMsg) override;
  std::optional<FlutterError> SetVolume(
      const VolumeMessage &volumeMsg) override;
  std::optional<FlutterError> SetPlaybackSpeed(
      const PlaybackSpeedMessage &speedMsg) override;
  std::optional<FlutterError> Play(const TextureMessage &textureMsg) override;
  std::optional<FlutterError> Pause(const TextureMessage &textureMsg) override;
  ErrorOr<std::unique_ptr<PositionMessage>> Position(
      const TextureMessage &textureMsg) override;
  std::optional<FlutterError> SeekTo(
      const PositionMessage &positionMsg) override;
  std::optional<FlutterError> SetMixWithOthers(
      const MixWithOthersMessage &mixWithOthersMsg) override;
  std::optional<FlutterError> SetDisplayRoi(
      const GeometryMessage &geometryMsg) override;
  ErrorOr<bool> SetBufferingConfig(
      const BufferingConfigMessage &configMsg) override;
  void SetLicenseData(void *response_data, size_t response_len,
                      int64_t player_id);

 private:
  void DisposeAllPlayers();
  FlutterDesktopPluginRegistrarRef registrar_ref_;
  VideoPlayerOptions options_;
  flutter::PluginRegistrar *plugin_registrar_;
  std::map<int64_t, std::unique_ptr<VideoPlayer>> players_;
};

std::unique_ptr<VideoPlayerTizenPlugin> plugin_;

void VideoPlayerTizenPlugin::RegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar_ref,
    flutter::PluginRegistrar *plugin_registrar) {
  plugin_ =
      std::make_unique<VideoPlayerTizenPlugin>(registrar_ref, plugin_registrar);
}

VideoPlayerTizenPlugin::VideoPlayerTizenPlugin(
    FlutterDesktopPluginRegistrarRef registrar_ref,
    flutter::PluginRegistrar *plugin_registrar)
    : registrar_ref_(registrar_ref), plugin_registrar_(plugin_registrar) {
  VideoPlayerApi::SetUp(plugin_registrar_->messenger(), this);
}

VideoPlayerTizenPlugin::~VideoPlayerTizenPlugin() { DisposeAllPlayers(); }

void VideoPlayerTizenPlugin::SetLicenseData(void *response_data,
                                            size_t response_len,
                                            int64_t player_id) {
  LOG_INFO("SetLicenseData,player_id:%d", player_id);
  auto iter = players_.find(player_id);
  if (iter != players_.end()) {
    iter->second->SetLicenseData(response_data, response_len);
  }
}

void VideoPlayerTizenPlugin::DisposeAllPlayers() {
  auto iter = players_.begin();
  while (iter != players_.end()) {
    iter->second->Dispose();
    iter++;
  }
  players_.clear();
}

std::optional<FlutterError> VideoPlayerTizenPlugin::Initialize() {
  DisposeAllPlayers();
  return {};
}

ErrorOr<std::unique_ptr<TextureMessage>> VideoPlayerTizenPlugin::Create(
    const CreateMessage &createMsg) {
  std::unique_ptr<VideoPlayer> player =
      std::make_unique<VideoPlayer>(registrar_ref_, createMsg);
  player->GetChallengeData(ChallengeCb);
  int64_t textureId = player->Create();
  players_[textureId] = std::move(player);
  std::unique_ptr<TextureMessage> texture_message =
      std::make_unique<TextureMessage>();
  texture_message->set_texture_id(textureId);
  return ErrorOr<TextureMessage>::MakeWithUniquePtr(std::move(texture_message));
}

std::optional<FlutterError> VideoPlayerTizenPlugin::Dispose(
    const TextureMessage &textureMsg) {
  auto iter = players_.find(textureMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->Dispose();
    players_.erase(iter);
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SetLooping(
    const LoopingMessage &loopingMsg) {
  auto iter = players_.find(loopingMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->SetLooping(loopingMsg.is_looping());
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SetVolume(
    const VolumeMessage &volumeMsg) {
  auto iter = players_.find(volumeMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->SetVolume(volumeMsg.volume());
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SetPlaybackSpeed(
    const PlaybackSpeedMessage &speedMsg) {
  auto iter = players_.find(speedMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->SetPlaybackSpeed(speedMsg.speed());
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::Play(
    const TextureMessage &textureMsg) {
  auto iter = players_.find(textureMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->Play();
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::Pause(
    const TextureMessage &textureMsg) {
  auto iter = players_.find(textureMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->Pause();
  }
  return {};
}

ErrorOr<std::unique_ptr<PositionMessage>> VideoPlayerTizenPlugin::Position(
    const TextureMessage &textureMsg) {
  std::unique_ptr<PositionMessage> result = std::make_unique<PositionMessage>();
  auto iter = players_.find(textureMsg.texture_id());
  if (iter != players_.end()) {
    result->set_texture_id(textureMsg.texture_id());
    result->set_position(iter->second->GetPosition());
  }
  return ErrorOr<PositionMessage>::MakeWithUniquePtr(std::move(result));
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SeekTo(
    const PositionMessage &positionMsg) {
  auto iter = players_.find(positionMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->SeekTo(positionMsg.position());
  }
  return {};
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SetDisplayRoi(
    const GeometryMessage &geometryMsg) {
  auto iter = players_.find(geometryMsg.texture_id());
  if (iter != players_.end()) {
    iter->second->SetDisplayRoi(geometryMsg.x(), geometryMsg.y(),
                                geometryMsg.w(), geometryMsg.h());
  }
  return {};
}

ErrorOr<bool> VideoPlayerTizenPlugin::SetBufferingConfig(
    const BufferingConfigMessage &configMsg) {
  auto iter = players_.find(configMsg.texture_id());
  if (iter != players_.end()) {
    return iter->second->SetBufferingConfig(configMsg.buffer_option(),
                                            configMsg.amount());
  }
  return ErrorOr<bool>(false);
}

std::optional<FlutterError> VideoPlayerTizenPlugin::SetMixWithOthers(
    const MixWithOthersMessage &mixWithOthersMsg) {
  options_.SetMixWithOthers(mixWithOthersMsg.mix_with_others());
  return {};
}

std::map<int64_t, Dart_Port> send_ports_;

}  // namespace

void VideoPlayerTizenPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  VideoPlayerTizenPlugin::RegisterWithRegistrar(
      registrar, flutter::PluginRegistrarManager::GetInstance()
                     ->GetRegistrar<flutter::PluginRegistrar>(registrar));
}

intptr_t VideoPlayerTizenPluginInitDartApi(void *data) {
  return Dart_InitializeApiDL(data);
}

void VideoPlayerTizenPluginRegisterSendPort(int64_t player_id,
                                            Dart_Port send_port) {
  send_ports_[player_id] = send_port;
}

static void FreeFinalizer(void *, void *value) { free(value); }

class PendingCall {
 public:
  PendingCall(void **buffer, size_t *length)
      : response_buffer_(buffer), response_length_(length) {
    receive_port_ =
        Dart_NewNativePort_DL("cpp-response", &PendingCall::HandleResponse,
                              /*handle_concurrently=*/false);
  }
  ~PendingCall() { Dart_CloseNativePort_DL(receive_port_); }

  Dart_Port port() const { return receive_port_; }

  void PostAndWait(Dart_Port port, Dart_CObject *object) {
    std::unique_lock<std::mutex> lock(mutex);
    const bool success = Dart_PostCObject_DL(port, object);
    if (!success) {
      LOG_ERROR("Failed to send message, invalid port or isolate died");
      return;
    }

    LOG_INFO("Waiting for result");
    while (!notified) {
      cv.wait(lock);
    }
  }

  static void HandleResponse(Dart_Port p, Dart_CObject *message) {
    if (message->type != Dart_CObject_kArray) {
      LOG_ERROR("Wrong Data: message->type != Dart_CObject_kArray");
    }
    Dart_CObject **c_response_args = message->value.as_array.values;
    Dart_CObject *c_pending_call = c_response_args[0];
    Dart_CObject *c_message = c_response_args[1];
    LOG_INFO("HandleResponse (call: %d)",
             reinterpret_cast<intptr_t>(c_pending_call));

    auto pending_call = reinterpret_cast<PendingCall *>(
        c_pending_call->type == Dart_CObject_kInt64
            ? c_pending_call->value.as_int64
            : c_pending_call->value.as_int32);

    pending_call->ResolveCall(c_message);
  }

 private:
  static bool NonEmptyBuffer(void **value) { return *value != nullptr; }

  void ResolveCall(Dart_CObject *bytes) {
    assert(bytes->type == Dart_CObject_kTypedData);
    if (bytes->type != Dart_CObject_kTypedData) {
      LOG_ERROR("C Wrong Data: bytes->type != Dart_CObject_kTypedData");
    }
    const intptr_t response_length = bytes->value.as_typed_data.length;
    const uint8_t *response_buffer = bytes->value.as_typed_data.values;

    void *buffer = malloc(response_length);
    memmove(buffer, response_buffer, response_length);

    *response_buffer_ = buffer;
    *response_length_ = response_length;

    notified = true;
    cv.notify_one();
  }

  std::mutex mutex;
  std::condition_variable cv;
  bool notified = false;

  Dart_Port receive_port_;
  void **response_buffer_;
  size_t *response_length_;
};

intptr_t ChallengeCb(uint8_t *challenge_data, size_t challenge_len,
                     int64_t player_id) {
  auto iter = send_ports_.find(player_id);
  if (iter == send_ports_.end()) {
    return 0;
  }
  Dart_Port send_port = iter->second;

  const char *methodname = "onLicenseChallenge";
  intptr_t result = 0;
  size_t request_length = challenge_len;
  void *request_buffer = malloc(request_length);
  memcpy(request_buffer, challenge_data, challenge_len);

  void *response_buffer = nullptr;
  size_t response_length = 0;

  PendingCall pending_call(&response_buffer, &response_length);

  Dart_CObject c_send_port;
  c_send_port.type = Dart_CObject_kSendPort;
  c_send_port.value.as_send_port.id = pending_call.port();
  c_send_port.value.as_send_port.origin_id = ILLEGAL_PORT;

  Dart_CObject c_pending_call;
  c_pending_call.type = Dart_CObject_kInt64;
  c_pending_call.value.as_int64 = reinterpret_cast<int64_t>(&pending_call);

  Dart_CObject c_method_name;
  c_method_name.type = Dart_CObject_kString;
  c_method_name.value.as_string = const_cast<char *>(methodname);

  Dart_CObject c_request_data;
  c_request_data.type = Dart_CObject_kExternalTypedData;
  c_request_data.value.as_external_typed_data.type = Dart_TypedData_kUint8;
  c_request_data.value.as_external_typed_data.length = request_length;
  c_request_data.value.as_external_typed_data.data =
      static_cast<uint8_t *>(request_buffer);
  c_request_data.value.as_external_typed_data.peer = request_buffer;
  c_request_data.value.as_external_typed_data.callback = FreeFinalizer;

  Dart_CObject *c_request_arr[] = {
      &c_send_port,
      &c_pending_call,
      &c_method_name,
      &c_request_data,
  };
  Dart_CObject c_request;
  c_request.type = Dart_CObject_kArray;
  c_request.value.as_array.values = c_request_arr;
  c_request.value.as_array.length =
      sizeof(c_request_arr) / sizeof(c_request_arr[0]);

  pending_call.PostAndWait(send_port, &c_request);
  LOG_INFO("Received result");

  plugin_->SetLicenseData(response_buffer, response_length, player_id);
  if (response_length != 0) {
    result = 1;
  }

  return result;
}
