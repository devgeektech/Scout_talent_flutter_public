import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:sizer/sizer.dart';

import '../../backend/model/get_my_messages_room_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commontext.dart';
import 'chat_inbox_logic.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  late String roomId;

  final ChatInboxLogic logic = Get.put(ChatInboxLogic(state: Get.find()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.fetchUsers();
    logic.fetchMyMessageRooms(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChatInboxLogic(state: Get.find()),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: ThemeProvider.bgColor,
            elevation: 0,
            title: CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "Chat".tr,
              fontSize: Utils.responsiveFontSize(context, 20.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  selectUserToChat(context, logic);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.h),
                      color: ThemeProvider.primary,
                    ),
                    child: Center(
                      child: CommonTextWidget(
                        textAlign: TextAlign.center,
                        heading: "New Chat".tr,
                        fontSize: Utils.responsiveFontSize(context, 18.sp),
                        fontWeight: FontWeight.w700,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),


          body: Obx(() {
            final rooms = logic.myMessageRooms.value?.data ?? [];

            if (logic.isLoadingRooms.value) {
              return Center(
                child: CircularProgressIndicator(color: ThemeProvider.primary),
              );
            }

            if (rooms.isEmpty) {
              return Center(
                child: CommonTextWidget(
                  heading: "No chats yet",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: ThemeProvider.gray,
                ),
              );
            }

            return RefreshIndicator(
              color: ThemeProvider.primary,
              onRefresh: ()async{
                await logic.fetchMyMessageRooms(context);
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  // Determine other users in the room
                  final myId = logic.state.sharedPreferencesManager.getString(
                    AppString.uid,
                  );
                  final otherUsers = room.users
                      .where((u) => u.id != myId)
                      .toList();

                  final lastMessage = room.messages.isNotEmpty
                      ? room.messages.first
                      : null;
                  return chatCardComponent(
                    context,
                    index,
                    (callBackIndex) {
                      // Pass room ID to chat screen
                      Get.toNamed(
                        AppRouter.chatScreenPage,
                        arguments: {"roomId": room.id, "users": room.users,"role":otherUsers.first.role?.capitalizeFirst??''},
                      );
                    },
                    room: room,
                    otherUsers: otherUsers,
                    lastMessage: lastMessage,
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  chatCardComponent(
    BuildContext context,
    int index,
    Function(int) callBack, {
    MessageRoomData? room,
    List<User>? otherUsers,
    Message? lastMessage,
  }) {
    return GestureDetector(
      onTap: () => callBack(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        margin: EdgeInsets.symmetric(vertical: .5.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: ThemeProvider.bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 22.sp,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:
                            (otherUsers != null &&
                                otherUsers.isNotEmpty &&
                                otherUsers.first.avatar != null &&
                                otherUsers.first.avatar!.isNotEmpty)
                            ? NetworkImage(
                                Utils.imageUrl + otherUsers.first.avatar!,
                              )
                            : null,
                        child:
                            (otherUsers == null ||
                                otherUsers.isEmpty ||
                                otherUsers.first.avatar == null ||
                                otherUsers.first.avatar!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.white70,
                              )
                            : null,
                      ),
                      if (otherUsers != null &&
                          otherUsers
                              .isNotEmpty) // Assuming your User model has isOnline
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: ThemeProvider.greenColor,
                              border: Border.all(
                                color: ThemeProvider.bgColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(
                          heading: otherUsers != null && otherUsers.isNotEmpty
                              ? otherUsers
                              .map((e) => "${e.firstName ?? ''} ${e.lastName ?? ''}".trim())
                              .join(", ")
                              : "Unknown",

                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        CommonTextWidget(
                          heading: lastMessage?.message ?? "No messages yet",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ThemeProvider.gray,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CommonTextWidget(
                  heading: otherUsers != null && otherUsers.isNotEmpty
                      ? otherUsers.first.role?.capitalizeFirst ?? ""
                      : "",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.primary,
                ),
                SizedBox(height: 0.5.h),
                CommonTextWidget(
                  heading: lastMessage?.createdAt != null
                      ? formatTimeforComments(lastMessage!.createdAt!)
                      : "",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: ThemeProvider.gray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectUserToChat(
    BuildContext context,
    ChatInboxLogic logic,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Optional: search inside dialog
            return AlertDialog(
              backgroundColor: ThemeProvider.alertColor,
              title: CommonTextWidget(
                textAlign: TextAlign.center,
                heading: "Start Chat".tr,
                fontSize: Utils.responsiveFontSize(context, 20.sp),
                fontWeight: FontWeight.w600,
                color: ThemeProvider.primary,
                fontFamily: "Montserrat",
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 60.h, // limit dialog height
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: logic.searchController,
                      onChanged: (value) {
                        logic.onSearch(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search player or coach here...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // User list
                    Expanded(
                      child: Obx(() {
                        if (logic.isLoading.value && logic.users.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (logic.users.isEmpty) {
                          return Center(
                            child: CommonTextWidget(
                              heading: "No users found",
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontWeight: FontWeight.w400,
                              color: ThemeProvider.gray,
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: logic.scrollController,
                          itemCount:
                              logic.users.length +
                              (logic.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= logic.users.length) {
                              print("⚡ Loading more indicator at index $index");
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final user = logic.users[index];
                            print(
                              "🟢 Rendering user at index $index: ${user.firstName} ${user.lastName}, id=${user.id}",
                            );

                            return Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22.sp,
                                            backgroundColor:
                                                Colors.grey.shade800,
                                            backgroundImage:
                                                (user.avatar != null &&
                                                    user.avatar!.isNotEmpty)
                                                ? NetworkImage(
                                                    Utils.imageUrl +
                                                        user.avatar!,
                                                  )
                                                : null,
                                            child:
                                                (user.avatar == null ||
                                                    user.avatar!.isEmpty)
                                                ? const Icon(
                                                    Icons.person,
                                                    size: 35,
                                                    color: Colors.white70,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 2.w),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonTextWidget(
                                                  heading:
                                                      "${user.firstName ?? ''} ${user.lastName ?? ''}",
                                                  fontSize:
                                                      Utils.responsiveFontSize(
                                                        context,
                                                        16.sp,
                                                      ),
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ThemeProvider.whiteColor,
                                                  maxLines: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: "Montserrat",
                                                ),
                                                SizedBox(height: 1.h),
                                                CommonTextWidget(
                                                  heading:
                                                      user
                                                          .role
                                                          ?.capitalizeFirst ??
                                                      "",
                                                  fontSize:
                                                      Utils.responsiveFontSize(
                                                        context,
                                                        14.sp,
                                                      ),
                                                  fontWeight: FontWeight.w400,
                                                  color: ThemeProvider.primary,
                                                  maxLines: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: "Montserrat",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Fixed width InkWell container for the share icon
                                    SizedBox(
                                      width: 50,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () async {
                                            print(
                                              "🖱 Share icon tapped for user id=${user.id}",
                                            );

                                            final myId =
                                                logic
                                                    .state
                                                    .sharedPreferencesManager
                                                    .getString(AppString.uid) ??
                                                '';
                                            print("🧩 My ID: $myId");

                                            if (myId.isEmpty ||
                                                user.id == null) {
                                              print(
                                                "⚠️ Cannot create room: userId or myId is empty",
                                              );
                                              return;
                                            }

                                            try {
                                              print(
                                                "⏳ Creating message room with userIds: [$myId, ${user.id!}]",
                                              );

                                              final room = await logic
                                                  .createMessageRoom(
                                                    userIds: [myId, user.id!],
                                                    context: context,
                                                  );

                                              if (room != null &&
                                                  room.data != null) {
                                                print(
                                                  "✅ Room created successfully: ${room.data!.id}",
                                                );
                                                logic.fetchMyMessageRooms(context);

                                                Get.back();
                                                print(
                                                  "👥 Users in room: ${room.data!.users.map((e) => e.firstName).toList()}",
                                                );
                                              } else {
                                                print(
                                                  "⚠️ Failed to create room",
                                                );
                                              }
                                            } catch (e) {
                                              print(
                                                "🔥 Exception creating message room: $e",
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              "assets/icons/share.svg",
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
