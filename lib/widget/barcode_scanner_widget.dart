import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final Future<bool> Function(String) onResult;

  const BarcodeScannerWidget({super.key, required this.onResult});

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  late MobileScannerController cameraController;
  bool isProcessing = false;
  String? _lastScannedBarcode;
  bool? _lastScanValid;
  final List<String> _scannedBarcodes = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  Future<void> _playSuccessSound() async {
    try {
      await HapticFeedback.mediumImpact();
      const String successPath = 'sound/background.mp3';
      await _audioPlayer.play(AssetSource(successPath));
    } catch (e) {
      debugPrint('Error playing success sound: $e');
    }
  }

  Future<void> _playErrorSound() async {
    try {
      await HapticFeedback.heavyImpact();
      // Using background.mp3 as a fallback if specific error sound is missing
      const String errorPath = 'sound/background.mp3';
      await _audioPlayer.play(AssetSource(errorPath));
    } catch (e) {
      debugPrint('Error playing error sound: $e');
    }
  }

  Future<void> _showWrongBarcodeDialog(String code) async {
    return Get.dialog(
      AlertDialog(
        title: const Text(
          'Invalid Barcode',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text('The scanned barcode "$code" is not valid or already selected.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showScannedBarcodesDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Scanned Serials (${_scannedBarcodes.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
          ],
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        content: SizedBox(
          width: double.maxFinite,
          height: Get.height * 0.5,
          child: _scannedBarcodes.isEmpty
              ? const Center(child: Text("No serials scanned yet"))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _scannedBarcodes.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.qr_code, size: 20, color: Color(0xFF4F46E5)),
                      title: Text(_scannedBarcodes[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      dense: true,
                    );
                  },
                ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: cameraController,
            builder: (context, state, child) {
              final torchState = state.torchState;
              return IconButton(
                color: Colors.white,
                icon: Icon(
                  torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: torchState == TorchState.on ? Colors.yellow : Colors.white,
                ),
                iconSize: 28.0,
                onPressed: () => cameraController.toggleTorch(),
              );
            },
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: cameraController,
            builder: (context, state, child) {
              final facing = state.cameraDirection;
              return IconButton(
                color: Colors.white,
                icon: Icon(facing == CameraFacing.front ? Icons.camera_front : Icons.camera_rear),
                iconSize: 28.0,
                onPressed: () => cameraController.switchCamera(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              if (isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                final String code = barcodes.first.rawValue!;

                setState(() {
                  isProcessing = true;
                });

                try {
                  debugPrint('BARCODE SCANNED: $code');

                  bool isValid = await widget.onResult(code);

                  if (mounted) {
                    setState(() {
                      _lastScannedBarcode = code;
                      _lastScanValid = isValid;
                      if (isValid && !_scannedBarcodes.contains(code)) {
                        _scannedBarcodes.insert(0, code); // Add to the beginning
                      }
                    });
                  }

                  if (isValid) {
                    await _playSuccessSound();
                    // Small delay to prevent duplicate scans immediately on success
                    await Future.delayed(const Duration(seconds: 2));
                  } else {
                    await _playErrorSound();
                    if (mounted) {
                      // Stop camera immediately on error to show dialog
                      await cameraController.stop();

                      // Show dialog and wait for it to be dismissed
                      await _showWrongBarcodeDialog(code);

                      // Restart camera after dialog is closed
                      if (mounted) {
                        await cameraController.start();
                      }
                    }
                  }
                } catch (e) {
                  debugPrint('Error in onDetect: $e');
                } finally {
                  if (mounted) {
                    setState(() {
                      isProcessing = false;
                    });
                  }
                }
              }
            },
          ),
          // Scanner Overlay removed as requested
          if (isProcessing) const Center(child: CircularProgressIndicator(color: Colors.white)),
          // Bottom instruction and Done button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (_lastScannedBarcode != null)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: (_lastScanValid ?? true) ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(color: (_lastScanValid ?? true) ? Colors.green : Colors.red, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  (_lastScanValid ?? true) ? Icons.check_circle : Icons.error,
                                  color: (_lastScanValid ?? true) ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (_lastScanValid ?? true) ? "Valid Scan" : "Invalid Scan",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: (_lastScanValid ?? true) ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        _lastScannedBarcode!,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Prominent View Scanned Serials Button
                if (_scannedBarcodes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: _showScannedBarcodesDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 4)),
                          ],
                          border: Border.all(color: const Color(0xFF4F46E5), width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.list_alt_rounded, color: Color(0xFF4F46E5), size: 22),
                            const SizedBox(width: 12),
                            Text(
                              "View Scanned Serials (${_scannedBarcodes.length})",
                              style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: const Text("Scan multiple barcodes. Tap 'Done' when finished.", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "DONE",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  @override
  void dispose() {
    cameraController.stop();
    cameraController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
