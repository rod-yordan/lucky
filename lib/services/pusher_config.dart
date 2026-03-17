import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherConfig {
  late PusherChannelsFlutter pusher;
  final String appKey = '43bc7bcfe4694589cbf6'; 
  final String cluster = 'mt1'; 

  Function(Map<String, dynamic>)? onMessageReceived;

  Future<void> initPusher({
    required String channelName,
    required String eventName,
    required Function(dynamic) onEventTriggered,
  }) async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: appKey,
        cluster: cluster,
        onConnectionStateChange: (current, previous) {
          print('🔵 Pusher: $current -> $previous');
        },
        onError: (message, code, error) {
          print('🔴 Pusher error: $message');
        },
        onEvent: (event) {
          print('📨 Evento recibido: ${event.eventName}');
          if (event.eventName == eventName) {
            onEventTriggered(event);
          }
        },
      );

      await pusher.connect();
      await pusher.subscribe(
        channelName: channelName,
        onEvent: (event) {
          if (event.eventName == eventName) {
            onEventTriggered(event);
          }
        },
      );

      print('✅ Pusher conectado al canal: $channelName');
    } catch (e) {
      print('❌ Error iniciando Pusher: $e');
    }
  }

  Future<void> disconnect() async {
    await pusher.disconnect();
  }
}