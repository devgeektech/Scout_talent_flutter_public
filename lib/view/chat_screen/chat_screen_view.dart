import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/get_my_messages_chat_model.dart';
import 'package:scouttalent2/view/chat_screen/chat_screen_state.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../backend/helper/app_router.dart';
import '../../backend/model/get_my_messages_room_model.dart';
import '../../service/chat_socket_service.dart';
import '../../utils/app_assets.dart';
import '../../utils/string.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import 'chat_screen_logic.dart';

class ChatScreenPage extends StatefulWidget {
  const ChatScreenPage({super.key});

  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final ChatScreenLogic logic = Get.find<ChatScreenLogic>();

  /// Add this:
  final ScrollController scrollController = ScrollController();
  late final ChatSocketService socket;
  late Worker socketWorker;
  String? role;

  @override
  void initState() {
    super.initState();

    final roomId = Get.arguments['roomId'];
     role = Get.arguments['role']??'';
    final myId =
        logic.state.sharedPreferencesManager.getString(AppString.uid) ?? '';

    socket = Get.put(ChatSocketService(), permanent: false);
    socket.connect();

    socketWorker = ever(socket.isConnected, (connected) {
      if (!connected) return;

      socket.joinRoom(roomId + myId);

      socket.listenMessages((data) {
        if (data == null) return;

        try {
          final map = Map<String, dynamic>.from(data);
          final msg = RoomMessages.fromJson(map);

          final exists = logic.roomMessages.any((m) => m.id == msg.id);

          if (!exists) {
            logic.roomMessages.add(msg);
            scrollToBottom();
          }
        } catch (e) {
          debugPrint("❌ Socket parse error: $e");
        }
      });
    });

    socket.listChat((data) {
      if (data == 1) {
        logic.fetchLatestMessages(roomId);
      }
    });

    logic.fetchRoomMessages(roomId);
  }

  @override
  void dispose() {
    debugPrint("🧹 ChatScreen dispose");

    socketWorker.dispose();
    socket.disconnect();

    if (Get.isRegistered<ChatSocketService>()) {
      Get.delete<ChatSocketService>(force: true);
    }

    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get myId
    final myId =
        logic.state.sharedPreferencesManager.getString(AppString.uid) ?? '';

    // Get the other participant
    final receiver = (Get.arguments['users'] as List<dynamic>)
        .cast<User?>()
        .firstWhereOrNull((u) => u!.id != myId);
    return GetBuilder(
      init: ChatScreenLogic(state: Get.find()),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ThemeProvider.bgColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: ThemeProvider.bgColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              leadingWidth: double.infinity,
              toolbarHeight: Get.height * .140,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: ThemeProvider.bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  spacing: 1,
                  children: [
                    Container(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 1.h,
                        horizontal: 2.w,
                      ),
                      margin: EdgeInsetsGeometry.symmetric(
                        vertical: .5.h,
                        horizontal: 15,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: .8.h,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 2.w,
                              children: [
                                CommonBackButton(
                                    size: 16,
                                    onTap: () => Get.back()),

                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 22.sp,
                                      backgroundColor: Colors.grey.shade800,
                                      backgroundImage:
                                          receiver?.avatar != null &&
                                              receiver!.avatar!.isNotEmpty
                                          ? NetworkImage(
                                              Utils.imageUrl +
                                                  receiver!.avatar!,
                                            )
                                          : null,
                                      // fallback to default color/icon if no image
                                      child:
                                          (receiver?.avatar == null ||
                                              receiver!.avatar!.isEmpty)
                                          ? Icon(
                                              Icons.person,
                                              size: 35,
                                              color: Colors.white70,
                                            )
                                          : null, // don't show icon if image exists
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 8,
                                      child: Container(
                                        height: 13,
                                        width: 13,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.greenColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Get myId

                                // Get the other participant

                                // Now in the header
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 1.h,
                                    children: [
                                      CommonTextWidget(
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        heading: (receiver != null
                                            ? '${receiver.firstName ?? ''} ${receiver.lastName ?? ''}'
                                            : 'Unknown'),
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          16.sp,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: "Montserrat",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: role?.capitalizeFirst ?? "",
                            fontSize: Utils.responsiveFontSize(context, 14.sp),
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.primary,
                            fontFamily: "Montserrat",
                          ),
                        ],
                      ),
                    ),
                    Divider(color: ThemeProvider.textColor.withAlpha(30)),
                  ],
                ),
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [],
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Obx(() {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToBottom(); // scroll to last message
                      });

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: logic.roomMessages.length,
                        itemBuilder: (context, index) {
                          final msg = logic.roomMessages[index];
                          final isMe = msg.sender == logic.myId;

                          final currentDate = msg.createdAt?.toLocal() ?? DateTime.now();

                          final prevMsg =
                          index > 0 ? logic.roomMessages[index - 1] : null;
                          final nextMsg =
                          index + 1 < logic.roomMessages.length
                              ? logic.roomMessages[index + 1]
                              : null;

                          /// 🟡 DATE HEADER (Today / Yesterday / Date)
                          final showDateHeader = prevMsg == null ||
                              !isSameDay(
                                currentDate,
                                prevMsg.createdAt!.toLocal(),
                              );

                          /// 🟢 GROUPING LOGIC
                          final showHeader =
                              prevMsg == null || prevMsg.sender != msg.sender;

                          final showTime =
                              nextMsg == null || nextMsg.sender != msg.sender;

                          return Column(
                            children: [
                              /// 📅 DATE SEPARATOR
                              if (showDateHeader)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ThemeProvider.whiteColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        getDateLabel(currentDate),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              /// 💬 MESSAGE BUBBLE
                              isMe
                                  ? senderBubble(
                                context,
                                msg.message ?? '',
                                currentDate,
                                msg.senderDetail?.avatar,
                                showHeader: showHeader,
                                showTime: showTime,
                              )
                                  : receiverBubble(
                                context,
                                msg.message ?? '',
                                currentDate,
                                msg.senderDetail?.avatar,
                                '${msg.senderDetail?.firstName ?? ''} ${msg.senderDetail?.lastName ?? ''}',
                                showHeader: showHeader,
                                showTime: showTime,
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),

                  Divider(color: ThemeProvider.textColor.withAlpha(30)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    child: CustomTextField(
                      controller: logic.messageController,
                      hintText: "Send a message...".tr,
                      suffixIcon: InkWell(
                        onTap: () async {
                          final text = logic.messageController.text.trim();
                          if (text.isEmpty) return;

                          // Determine receiver ID safely
                          final users = Get.arguments['users'] as List<dynamic>;
                          final myId =
                              logic.state.sharedPreferencesManager.getString(
                                AppString.uid,
                              ) ??
                              '';

                          // Pick the other participant in 1-on-1 chat
                          final receiverUser = users
                              .cast<User?>()
                              .firstWhereOrNull((u) => u!.id != myId);

                          final receiverId = receiverUser?.id ?? '';

                          debugPrint(
                            "✅ Sending message to receiverId: $receiverId",
                          );
                          if (receiverId.isEmpty) return; // safety check

                          final result = await logic.sendMessage(
                            message: text,
                            receiverId: receiverId,
                            roomId: Get.arguments['roomId'],
                          );

                          if (result?.data != null) {
                            final apiMessage = result!.data!;

                            final sentMessage = RoomMessages(
                              id: apiMessage.id,
                              message: apiMessage.message,
                              sender: apiMessage.sender,
                              receiver: apiMessage.receiver,
                              isSeen: apiMessage.isSeen ?? false,
                              createdAt: apiMessage.createdAt,
                              senderDetail: apiMessage.senderDetail != null
                                  ? ErDetail(
                                      id: apiMessage.senderDetail!.id,
                                      firstName:
                                          apiMessage.senderDetail!.firstName,
                                      lastName:
                                          apiMessage.senderDetail!.lastName,
                                      email: apiMessage.senderDetail!.email,
                                      avatar: apiMessage.senderDetail!.avatar,
                                    )
                                  : null,
                              receiverDetail: apiMessage.receiverDetail != null
                                  ? ErDetail(
                                      id: apiMessage.receiverDetail!.id,
                                      firstName:
                                          apiMessage.receiverDetail!.firstName,
                                      lastName:
                                          apiMessage.receiverDetail!.lastName,
                                      email: apiMessage.receiverDetail!.email,
                                      avatar: apiMessage.receiverDetail!.avatar,
                                    )
                                  : null,
                            );

                            // Prevent duplicates
                            final exists = logic.roomMessages.any(
                              (m) => m.id == sentMessage.id,
                            );

                            if (!exists) {
                              logic.roomMessages.add(sentMessage);
                            }

                            // Emit socket for receiver
                            final socket = Get.find<ChatSocketService>();
                            socket.emitMessageFromApi(
                              userId: myId,
                              roomId: Get.arguments['roomId'],
                              messageData: apiMessage,
                            );
                          }

                          logic.messageController.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(AssetPath.sendIcon),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget senderBubble(
      BuildContext context,
      String message,
      DateTime time,
      String? avatar, {
        required bool showHeader,
        required bool showTime,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 💬 Message + Time
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                /// 💬 Bubble
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration:  BoxDecoration(
                    color: ThemeProvider.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    message,
                    style:  TextStyle(color: Colors.white,),
                  ),
                ),

                /// ⏰ Time (only last message)
                if (showTime)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 6),
                    child: Text(
                      formatTimeforComments(time.toLocal()),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget receiverBubble(
      BuildContext context,
      String message,
      DateTime time,
      String? avatar,
      String? name, {
        required bool showHeader,
        required bool showTime,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 👤 Avatar ONLY on first message
          if (showHeader)
            CircleAvatar(
              radius: 16,
              backgroundImage: avatar != null && avatar.isNotEmpty
                  ? NetworkImage(Utils.imageUrl + avatar)
                  : null,
              child: avatar == null || avatar.isEmpty
                  ? const Icon(Icons.person, size: 18)
                  : null,
            )
          else
            const SizedBox(width: 32),

          const SizedBox(width: 8),

          /// 💬 Name + Bubble + Time
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name ONLY on first message
                if (showHeader && name != null && name.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.primary,
                      ),
                    ),
                  ),
                /// 🔥 Bubble + time wrapper
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// 💬 Bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: ThemeProvider.whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Text(message,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),

                      /// ⏰ Time ONLY on last message
                      if (showTime)
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 4, right: 6),
                          child: Text(
                            formatTimeforComments(time.toLocal()),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }






  Widget bubble(String msg, Color bg, Color color) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(msg, style: TextStyle(color: color,fontWeight: FontWeight.bold)),
  );

  senderSide(BuildContext context, int index, ChatMessage message) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        direction: Axis.vertical,
        spacing: .8.h,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: Get.width * .08,
              maxWidth: Get.width * .8,
            ),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeProvider.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: CommonTextWidget(
              textAlign: TextAlign.start,
              heading: message.message,
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
          ),

          CommonTextWidget(
            textAlign: TextAlign.start,
            heading: getDateLabel(message.createdAt),
            fontSize: Utils.responsiveFontSize(context, 12.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.gray,
            fontFamily: "Montserrat",
          ),
        ],
      ),
    );
  }

  receiverSide(BuildContext context, int index, ChatMessage message) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        direction: Axis.vertical,
        spacing: .8.h,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: Get.width * .08,
              maxWidth: Get.width * .8,
            ),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeProvider.whiteChat,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: CommonTextWidget(
              textAlign: TextAlign.start,
              heading: message.message,
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.blackColor,
              fontFamily: "Montserrat",
            ),
          ),

          CommonTextWidget(
            textAlign: TextAlign.start,
            heading: getDateLabel(message.createdAt),
            fontSize: Utils.responsiveFontSize(context, 12.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.gray,
            fontFamily: "Montserrat",
          ),
        ],
      ),
    );
  }
}
