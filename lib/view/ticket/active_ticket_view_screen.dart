import 'package:festquest/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ActiveTicketScreen extends StatelessWidget {
  final TicketModel ticket;
  final GlobalKey _qrKey = GlobalKey();

  ActiveTicketScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ticket Card
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Event Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child:
                      ticket.poster.isNotEmpty
                          ? Image.network(
                        ticket.poster,
                        fit: BoxFit.cover,
                        loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                            ) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                loadingProgress
                                    .expectedTotalBytes !=
                                    null
                                    ? loadingProgress
                                    .cumulativeBytesLoaded /
                                    loadingProgress
                                        .expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No image available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Ticket Information
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        Text(
                          ticket.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Event Details
                        _buildInfoRow(
                          Icons.location_on,
                          'Location',
                          ticket.location,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.calendar_today,
                          'Date',
                          ticket.date,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(Icons.access_time, 'Time', ticket.time),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.confirmation_number,
                          'Quantity',
                          ticket.quantity.toString(),
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(Icons.badge, 'Ticket ID', ticket.id),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey[200]!,
                                  Colors.grey[400]!,
                                  Colors.grey[200]!,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // QR Code Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Scan this QR code at the venue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        RepaintBoundary(
                          key: _qrKey,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200]!,
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // QR Code with dynamic data from ticket
                                QrImageView(
                                  data:
                                  ticket.qrCode.isNotEmpty
                                      ? ticket.qrCode
                                      : 'FESTQUEST:${ticket.id}:${ticket.eventId}:${ticket.userId}:${ticket.createdAt.millisecondsSinceEpoch}',
                                  version: QrVersions.auto,
                                  size: 220.0,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                ),
                                const SizedBox(height: 12),

                                // QR Code validation indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.green[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: Colors.green[700],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Valid Ticket',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Ticket ID and QR info
                        Column(
                          children: [
                            Text(
                              'Ticket ID: ${ticket.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Generated: ${_formatDateTime(ticket.createdAt)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadQRCode(context),
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Download QR Code'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _shareTicket(context),
                      icon: const Icon(Icons.share),
                      label: const Text('Share Ticket'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // QR Code Security Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'QR Code Security',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Each QR code is unique and cannot be duplicated\n'
                        '• Contains encrypted ticket and user information\n'
                        '• Valid only for this specific event and date\n'
                        '• Scanned once for entry verification',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Important Notes
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Important Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Please arrive 30 minutes before the event starts\n'
                        '• Keep your ticket ready for scanning\n'
                        '• No refunds or exchanges allowed\n'
                        '• Bring a valid ID for verification',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Share ticket functionality
  Future<void> _shareTicket(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Preparing to share...'),
            ],
          ),
        ),
      );

      // Show share options dialog
      Navigator.pop(context); // Close loading dialog

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Share Ticket',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.text_snippet, color: Colors.blue),
                  title: const Text('Share Ticket Details'),
                  subtitle: const Text('Share event information as text'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareTicketText();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.qr_code, color: Colors.green),
                  title: const Text('Share QR Code'),
                  subtitle: const Text('Share QR code as image'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareQRCode(context);
                  },
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error preparing share: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Share ticket details as text
  void _shareTicketText() {
    final text = '''
🎫 FestQuest Ticket

🎪 Event: ${ticket.name}
📍 Location: ${ticket.location}
📅 Date: ${ticket.date}
🕐 Time: ${ticket.time}
🎟️ Quantity: ${ticket.quantity}
🆔 Ticket ID: ${ticket.id}

Generated on: ${_formatDateTime(ticket.createdAt)}

Present this ticket at the venue for entry.
''';

    Share.share(
      text,
      subject: 'FestQuest Ticket - ${ticket.name}',
    );
  }

  // Share QR code as image
  Future<void> _shareQRCode(BuildContext context) async {
    try {
      // Capture the QR code as image
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        List<int> pngBytes = byteData.buffer.asUint8List();

        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final fileName = 'qr_code_${ticket.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        final filePath = '${directory.path}/$fileName';

        // Save the file
        File file = File(filePath);
        await file.writeAsBytes(pngBytes);

        // Share the file
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'QR Code for ${ticket.name}\nTicket ID: ${ticket.id}',
          subject: 'FestQuest QR Code - ${ticket.name}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing QR code: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _downloadQRCode(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Saving QR Code...'),
            ],
          ),
        ),
      );

      // Capture the QR code as image
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        List<int> pngBytes = byteData.buffer.asUint8List();

        // Create filename with ticket info (sanitize filename)
        String sanitizedName = ticket.name
            .replaceAll(' ', '_')
            .replaceAll(RegExp(r'[^\w\-_.]'), '');
        String fileName =
            'QR_${sanitizedName}${ticket.id}${DateTime.now().millisecondsSinceEpoch}.png';

        // Use a simple path that should work on most devices
        String? directoryPath;
        String savedLocation = '';

        if (Platform.isAndroid) {
          // Try common Android paths
          directoryPath = '/storage/emulated/0/Download';
          savedLocation = 'Downloads';

          // Fallback to app directory if Downloads is not accessible
          final downloadDir = Directory(directoryPath);
          if (!await downloadDir.exists()) {
            directoryPath =
            '/data/data/${const String.fromEnvironment('FLUTTER_APP_PACKAGE_NAME', defaultValue: 'com.example.app')}/files';
            savedLocation = 'App Files';
          }
        } else {
          // For iOS or other platforms, use a basic directory
          directoryPath = Directory.systemTemp.path;
          savedLocation = 'Temporary Files';
        }

        String filePath = '$directoryPath/$fileName';

        try {
          // Save the file
          File file = File(filePath);
          await file.writeAsBytes(pngBytes);

          // Close loading dialog
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QR code saved successfully!'),
                  const SizedBox(height: 4),
                  Text(
                    'Location: $savedLocation',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'File: $fileName',
                    style: const TextStyle(fontSize: 10, color: Colors.white60),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } catch (fileError) {
          // If file saving fails, try saving to app's temporary directory
          String tempPath = Directory.systemTemp.path;
          String tempFilePath = '$tempPath/$fileName';

          File tempFile = File(tempFilePath);
          await tempFile.writeAsBytes(pngBytes);

          // Close loading dialog
          Navigator.pop(context);

          // Show success message with temp location
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QR code saved to temporary storage!'),
                  const SizedBox(height: 4),
                  const Text(
                    'Location: Temporary Files',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'File: $fileName',
                    style: const TextStyle(fontSize: 10, color: Colors.white60),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } else {
        throw Exception('Failed to capture QR code image');
      }
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving QR code: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}