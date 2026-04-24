import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class QRVerificationScreen extends StatefulWidget {
  const QRVerificationScreen({super.key});

  @override
  State<QRVerificationScreen> createState() => _QRVerificationScreenState();
}

class _QRVerificationScreenState extends State<QRVerificationScreen> {
  MobileScannerController scannerController = MobileScannerController();
  bool isScanning = true;
  String? scannedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Verification'),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.qr_code_scanner : Icons.cancel),
            onPressed: () {
              setState(() {
                isScanning = !isScanning;
                if (isScanning) {
                  scannedData = null;
                  scannerController.start();
                } else {
                  scannerController.stop();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isScanning)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          setState(() {
                            scannedData = barcode.rawValue;
                            isScanning = false;
                            scannerController.stop();
                          });
                          _verifyQRCode(context, barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          if (scannedData != null)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'QR Code Verified!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Appointment verified successfully',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          scannedData = null;
                          isScanning = true;
                          scannerController.start();
                        });
                      },
                      child: const Text('Scan Another QR Code'),
                    ),
                  ],
                ),
              ),
            ),
          if (!isScanning && scannedData == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No QR Code Detected',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isScanning = true;
                          scannerController.start();
                        });
                      },
                      child: const Text('Start Scanning'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _verifyQRCode(BuildContext context, String qrData) {
    // Here you would verify the QR code data with Firebase
    print('QR Code Data: $qrData');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code verified successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}