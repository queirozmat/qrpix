import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPage extends StatefulWidget {
  final String pix;
  const PixPage({super.key, required this.pix});

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            QrImageView(
              data: widget.pix,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                widget.pix,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.pix));
                },
                child: const Text('Copiar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
