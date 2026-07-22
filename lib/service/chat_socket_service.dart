import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../backend/model/send_message_model.dart';

class ChatSocketService extends GetxService {
  late IO.Socket socket;
  final RxBool isConnected = false.obs;

  /// CONNECT
  void connect() {
    if (isConnected.value) return;

    socket = IO.io(
      'https://scouttalent.api.geektechies.com',
      IO.OptionBuilder()
          .setPath('/socket.io/')
          .setTransports(['websocket'])
          .enableReconnection()
      // ❌ REMOVED disableAutoConnect()
          .setTimeout(20000)
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected.value = true;
      print("✅ Socket connected: ${socket.id}");
    });

    socket.onDisconnect((reason) {
      isConnected.value = false;
      print("❌ Socket disconnected: $reason");
    });

    socket.onConnectError((err) {
      print("❌ Socket connect error: $err");
    });

    socket.onError((err) {
      print("❌ Socket error: $err");
    });
  }

  /// JOIN ROOM (backend expects ONLY userId)
  void joinRoom(String userId) {
    if (!socket.connected) return;

    socket.emit("joinRoom", userId);
    print("🟢 joinRoom emitted: $userId");
  }

  /// SEND MESSAGE
  /// backend: sendMessage(userId, roomId, payload)
  void sendMessage({
    required String userId,
    required String roomId,
    required String message,
  }) {
    if (!socket.connected) {
      print("⚠️ Socket not connected");
      return;
    }

    final payload = {
      "sender": userId,
      "message": message,
      "createdAt": DateTime.now().toIso8601String(),
    };

    socket.emit(
      "sendMessage",
      [userId, roomId, payload], // ORDER MATTERS
    );

    print("📤 sendMessage → $payload");
  }

  /// LISTEN CHAT MESSAGES
  void listenMessages(Function(dynamic data) onMessage) {
    print("Listening+++++++++");
    // socket.off("receiveMessage");
    socket.on("receiveMessage", (data) {
      print("📤 receiveMessage received → $data");
      onMessage(data);
    });
  }

  void listChat(Function(dynamic data) onMessage) {
    // socket.off("receiveChat");
    socket.on("receiveChat", (data) {
      print("📩 receiveChat: $data");

      // socket.on("receiveMessage", (data) {
      //   print("📤 receiveMessage received → $data");
      //   onMessage(data);
      // });
      onMessage(data);
    });
  }

  /// TEST EVENT (health check + ACK)
  void testSocket() {
    if (!socket.connected) return;

    socket.emitWithAck(
      "testEvent",
      {
        "from": "flutter",
        "time": DateTime.now().toIso8601String(),
      },
      ack: (response) {
        print("✅ testEvent ACK: $response");
      },
    );

    print("🧪 testEvent emitted");
  }

  /// LISTEN TEST RESPONSE
  void listenTestResponse() {
    socket.off("testResponse");
    socket.on("testResponse", (data) {
      print("🧪 testResponse: $data");
    });
  }

  /// DISCONNECT
  void disconnect() {
    if (!isConnected.value) return;

    socket.dispose();
    isConnected.value = false;
    print("🔴 Socket manually disconnected");
  }

  void emitMessageFromApi({
    required String userId,
    required String roomId,
    required Data messageData,
  }) {
    if (!socket.connected) {
      print("❌ Socket not connected. Message not sent.");
      return;
    }

    final payload = [
      userId,
      roomId,
      messageData.toJson(),
    ];

    /// 🔍 DEBUG PRINTS
    print("📤 SOCKET EMIT → sendMessage");
    print("➡️ userId   : $userId");
    print("➡️ roomId   : $roomId");
    print("➡️ payload  : ${messageData.toJson()}");
    print("➡️ full args: $payload");

    socket.emit(
      "sendMessage",
      payload,
    );

    print("✅ sendMessage emitted successfully");
  }


}
