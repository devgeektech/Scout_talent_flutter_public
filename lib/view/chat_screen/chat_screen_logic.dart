import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/toast.dart';

import '../../backend/model/get_my_messages_chat_model.dart';
import '../../backend/model/send_message_model.dart';
import '../../utils/string.dart';
import 'chat_screen_state.dart';

class ChatScreenLogic extends GetxController {
  final ChatScreenState state;

  ChatScreenLogic({required this.state});
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose(); // dispose to avoid memory leaks
    super.dispose();
  }
  final List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      message: 'Hello',
      createdAt: DateTime.now(),
      isSender: true,
    ),
    ChatMessage(
      id: '2',
      message: 'Hi 👋',
      createdAt: DateTime.now(),
      isSender: false,
    ),
    ChatMessage(
      id: '3',
      message: 'How are you?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isSender: true,
    ),
    ChatMessage(
      id: '4',
      message: 'I am good',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isSender: false,
    ),



    ChatMessage(
      id: '4',
      message: 'I am good',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isSender: false,
    ),


    ChatMessage(
      id: '3',
      message: 'How are you?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isSender: true,
    ),

    ChatMessage(
      id: '4',
      message: 'I am good',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isSender: false,
    ),

    ChatMessage(
      id: '3',
      message: 'How are you?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isSender: true,
    ),

    ChatMessage(
      id: '4',
      message: 'I am good',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isSender: false,
    ),
    ChatMessage(
      id: '3',
      message: 'How are you?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isSender: true,
    ),


    ChatMessage(
      id: '4',
      message: 'I am good',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isSender: false,
    ),


  ];

  RxList<RoomMessages> roomMessages = <RoomMessages>[].obs;
  RxBool isLoadingMessages = false.obs;
  RxInt currentPage = 1.obs;
  RxBool hasMoreMessages = true.obs;
  String get myId => state.sharedPreferencesManager.getString(AppString.uid) ?? '';




  Future<void> fetchLatestMessages(String roomId) async {
    try {
      isLoadingMessages.value = true;

      // Hit page 1 to get the newest messages
      final res = await getRoomMessages(
        roomId: roomId,
        page: 1,
        limit: 20,
      );

      if (res == null || res.data == null || res.data!.isEmpty) return;

      // Get existing message IDs
      final existingIds = roomMessages.map((e) => e.id).toSet();

      // Only new messages
      final newMessages =
      res.data!.where((msg) => !existingIds.contains(msg.id)).toList();

      if (newMessages.isNotEmpty) {
        // Append new messages to the bottom
        roomMessages.addAll(newMessages.reversed); // oldest → newest
        debugPrint("✅ Added ${newMessages.length} new messages from socket");
      }
    } catch (e) {
      debugPrint("🔥 fetchLatestMessages error: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  Future<void> fetchRoomMessages(String roomId, {bool loadMore = false}) async {
    if (isLoadingMessages.value || (!loadMore && !hasMoreMessages.value)) return;

    isLoadingMessages.value = true;

    int pageToFetch = currentPage.value;

    // Only clear list on initial load if not adding new local messages
    if (!loadMore && roomMessages.isEmpty) {
      currentPage.value = 1;
      roomMessages.clear();
      hasMoreMessages.value = true;
      pageToFetch = 1;
    }

    try {
      final res = await getRoomMessages(
        roomId: roomId,
        page: pageToFetch,
        limit: 20,
      );

      if (res != null && res.data != null && res.data!.isNotEmpty) {
        final newMessages = res.data!;

        if (loadMore) {
          // Add older messages at top
          roomMessages.insertAll(0, newMessages);
        } else {
          // Add latest messages at bottom but avoid duplicates
          final existingIds = roomMessages.map((e) => e.id).toSet();
          final filteredMessages =
          newMessages.where((msg) => !existingIds.contains(msg.id)).toList();

          roomMessages.addAll(filteredMessages);
        }

        currentPage.value++;
      } else {
        hasMoreMessages.value = false;
      }
    } catch (e) {
      debugPrint("🔥 fetchRoomMessages error: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }


  Future<GetMyMessagesChatModel?> getRoomMessages({
    required String roomId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await state.apiService.getApiWithHeader(
        "message/getRoomMessages?roomId=$roomId&page=$page&limit=$limit",
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return GetMyMessagesChatModel.fromJson(response!.data);
      } else {
        print("❌ Failed to load messages: ${response?.statusCode}");
        return null;
      }
    } catch (e, st) {
      print("🔥 getRoomMessages error: $e");
      print(st);
      return null;
    }
  }



  Future<SendMessageModel?> sendMessage({
    required String roomId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final myId =
          state.sharedPreferencesManager.getString(AppString.uid) ?? "";

      final payload = {
        "message": message,
        "room": roomId,
        "sender": myId,
        "receiver": receiverId,
      };

      final response = await state.apiService.postApiWithBody(
        "message",
        body: payload,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final res = SendMessageModel.fromJson(response!.data);

        if (res.responseCode == 200 || res.responseCode == 201) {
          return res; // ✅ RETURN API RESULT
        }
      }
    } catch (e) {
      debugPrint("Send message error: $e");
    }
    return null;
  }


}

