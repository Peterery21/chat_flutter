import 'package:flutter/material.dart';
import '../../config/chat_module.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget that displays a file attachment (PDF, Word, Excel, etc.)
/// inside a message bubble. Tapping opens the file via its URL.
class FileAttachmentWidget extends StatelessWidget {
  const FileAttachmentWidget({
    super.key,
    required this.fileUrl,
    required this.filename,
    this.isSender = false,
  });

  final String fileUrl;
  final String filename;
  final bool isSender;

  static const _extensionColors = {
    'pdf': Color(0xFFE53935),
    'doc': Color(0xFF1565C0),
    'docx': Color(0xFF1565C0),
    'xls': Color(0xFF2E7D32),
    'xlsx': Color(0xFF2E7D32),
    'ppt': Color(0xFFE65100),
    'pptx': Color(0xFFE65100),
    'zip': Color(0xFF6A1B9A),
    'rar': Color(0xFF6A1B9A),
  };

  static const _extensionIcons = {
    'pdf': Icons.picture_as_pdf,
    'doc': Icons.description,
    'docx': Icons.description,
    'xls': Icons.table_chart,
    'xlsx': Icons.table_chart,
    'ppt': Icons.slideshow,
    'pptx': Icons.slideshow,
    'zip': Icons.folder_zip,
    'rar': Icons.folder_zip,
  };

  String get _extension =>
      filename.contains('.') ? filename.split('.').last.toLowerCase() : '';

  Color get _iconColor =>
      _extensionColors[_extension] ?? ChatModule.theme.hintColor;

  IconData get _icon =>
      _extensionIcons[_extension] ?? Icons.insert_drive_file;

  Future<void> _open() async {
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    final textColor = isSender ? theme.appBarTextColor : theme.primaryTextColor;
    final subTextColor = isSender ? theme.appBarTextColor.withOpacity(0.7) : theme.hintColor;
    final bgColor = isSender
        ? theme.appBarTextColor.withOpacity(0.15)
        : theme.hintColor.withOpacity(0.1);

    return GestureDetector(
      onTap: _open,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: _iconColor, size: 32),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filename,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _extension.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: subTextColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        size: 11,
                        color: subTextColor,
                      ),
                    ],
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
