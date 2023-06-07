import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SensitiveDocument extends StatelessWidget {
  const SensitiveDocument({
    super.key,
    this.scale = 1.0,
    required this.shredMilliseconds,
    required this.delayMilliseconds,
  });

  final double scale;
  final int shredMilliseconds;
  final int delayMilliseconds;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          EncryptedView(
            durationMilliseconds: shredMilliseconds,
            delayMilliseconds: delayMilliseconds,
          ),
          PassportCard(
            durationMilliseconds: shredMilliseconds,
            delayMilliseconds: delayMilliseconds,
          ),
        ],
      ),
    );
  }
}

class EncryptedView extends StatefulWidget {
  const EncryptedView({
    super.key,
    required this.durationMilliseconds,
    required this.delayMilliseconds,
  });

  final int durationMilliseconds;
  final int delayMilliseconds;

  @override
  State<EncryptedView> createState() => _EncryptedViewState();
}

class _EncryptedViewState extends State<EncryptedView> {
  bool isTrue = true;
  String encryptedText = '';

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final randomString = List.generate(
      lengthOfString,
      (index) => allChars[random.nextInt(allChars.length)],
    ).join();
    return randomString;
  }

  startRandomGen() async {
    while (isTrue) {
      final stringGen = generateRandomString(600);
      setState(() => encryptedText = stringGen);
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  startAndStop() async {
    await Future.delayed(Duration(milliseconds: widget.delayMilliseconds));
    startRandomGen();
    await Future.delayed(Duration(milliseconds: widget.durationMilliseconds));
    setState(() {
      isTrue = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startAndStop();
  }

  final chunkSize = 50;

  @override
  Widget build(BuildContext context) {
    List<List<String>> chunks = [];

    for (var i = 0; i < encryptedText.length; i += chunkSize) {
      chunks.add(encryptedText.split('').sublist(
          i,
          i + chunkSize > encryptedText.length
              ? encryptedText.length
              : i + chunkSize));
    }
    return SizedBox(
      height: 377,
      width: 550,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          12,
          (index) => RichText(
            text: TextSpan(
              children: List.generate(
                chunkSize,
                (index2) => TextSpan(
                    text: chunks.isEmpty ? '' : chunks[index][index2],
                    style: TextStyle(
                      color: Random().nextDouble() < 0.04
                          ? Colors.white70
                          : const Color(0xFF6B6B6B),
                    )),
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 5,
                height: 1.54,
                shadows: [
                  Shadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.9),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            maxLines: 1,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class PassportCard extends StatefulWidget {
  const PassportCard({
    super.key,
    required this.durationMilliseconds,
    required this.delayMilliseconds,
  });

  final int durationMilliseconds;
  final int delayMilliseconds;

  @override
  State<PassportCard> createState() => _PassportCardState();
}

class _PassportCardState extends State<PassportCard> {
  double widthFactor = 1.0;
  start() async {
    await Future.delayed(Duration(milliseconds: widget.delayMilliseconds));
    setState(() => widthFactor = 0.0);
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedAlign(
        duration: Duration(milliseconds: widget.durationMilliseconds),
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          height: 365,
          width: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PASSPORT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/sample_passport_photo.png',
                            height: 210,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 26, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SURNAME',
                              style: TextStyle(
                                color: Color(0xFF6B6B6B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'DOE',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Text(
                                'FIRST NAME',
                                style: TextStyle(
                                  color: Color(0xFF6B6B6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'JOHN',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Text(
                                'NATIONALITY',
                                style: TextStyle(
                                  color: Color(0xFF6B6B6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'INDIAN',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Text(
                                'DATE OF ISSUE',
                                style: TextStyle(
                                  color: Color(0xFF6B6B6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '21 JUNE 2019',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARD NUMBER',
                            style: TextStyle(
                              color: Color(0xFF6B6B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'IN0453F563',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                            child: Text(
                              'DATE OF BIRTH',
                              style: TextStyle(
                                color: Color(0xFF6B6B6B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '12 APRIL 1999',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                            child: Text(
                              'EXPIRATION',
                              style: TextStyle(
                                color: Color(0xFF6B6B6B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '20 JUNE 2024',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PIN0453F563<<<<DOE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<',
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFF6B6B6B),
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                        child: Text(
                          '599IR345<<<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<',
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF6B6B6B),
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
