import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'commontext.dart';
import 'video_thumb.dart';

class TrialCard extends StatelessWidget {
  final String title;
  final String? category;
  final String? videoThumbnail;
  final String? thumbnail;
  final String? videoUrl;
  final String? logoUrl;
  final String? id;
  final String? createdByUser;

  /// Actions
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TrialCard({
    super.key,
    required this.title,
    this.category,
    this.createdByUser,
    this.videoThumbnail,
    this.videoUrl,
    this.logoUrl,
    this.id,
    this.onEdit,
    this.onDelete,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 12, // Fix height proportional to width
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Background: video thumbnail > logo > fallback
            if (thumbnail != null && thumbnail!.isNotEmpty)
              VideoThumb(
                showPlayButton: false,
                key: ValueKey(id),
                videoUrl: Utils.imageUrl1 + thumbnail!,
                thumbnail: thumbnail ?? "",
              )
            else if (logoUrl != null && logoUrl!.isNotEmpty)
              Image.network(
                Utils.imageUrl + logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  AssetPath.latestTransfer,
                  fit: BoxFit.cover,
                ),
              )
            else
              Image.asset(
                AssetPath.latestTransfer,
                fit: BoxFit.cover,
              ),

            /// Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// Edit/Delete menu
            if (onEdit != null || onDelete != null)
              Positioned(
                top: 6,
                right: 6,
                child: PopupMenuButton<_TrialMenuAction>(
                  icon: CircleAvatar(
                    radius: 10,
                    backgroundColor: ThemeProvider.primary,
                    child: const Icon(Icons.more_vert, size: 10, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (action) {
                    if (action == _TrialMenuAction.edit) onEdit?.call();
                    if (action == _TrialMenuAction.delete) onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: _TrialMenuAction.edit,
                        child: _MenuItem(icon: Icons.edit_outlined, text: 'Edit'.tr, color: Colors.black),
                      ),
                    PopupMenuItem(
                      enabled: false,
                      height: 1,
                      child: Divider(color: ThemeProvider.textColor.withOpacity(0.25)),
                    ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: _TrialMenuAction.delete,
                        child: _MenuItem(icon: Icons.delete, text: 'Delete'.tr, color: Colors.redAccent),
                      ),
                  ],
                ),
              ),

            /// Bottom-left content: optional small logo + title + category
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // prevents unbounded height
                children: [
                  /// Square logo overlay (optional)
                  if (logoUrl != null && logoUrl!.isNotEmpty && videoThumbnail!=null && videoThumbnail!.isNotEmpty  )
                    Container(
                      height: 8.h,
                      width: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(Utils.imageUrl + logoUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (logoUrl != null && logoUrl!.isNotEmpty) SizedBox(height: 1.h),
                  /// Title
                  CommonTextWidget(
                    heading: title,
                    fontSize: Utils.responsiveFontSize(context, 20.sp),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  SizedBox(height: 1.h,),
                  if (createdByUser != null && createdByUser!.isNotEmpty)
                    CommonTextWidget(
                      heading: "${'Club'.tr} - ${createdByUser ?? ""}",
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  SizedBox(height: 1.h,),

                  /// Category / Position
                  if (category != null && category!.isNotEmpty)
                    CommonTextWidget(
                      heading: "${'Position'.tr} - ${category?.capitalizeFirst ?? ""}",
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu actions enum
enum _TrialMenuAction { edit, delete }

/// Menu item widget
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MenuItem({
    required this.icon,
    required this.text,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
