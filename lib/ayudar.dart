import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';

class Ayudar extends StatelessWidget {
  const Ayudar({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.help_outline, size: 25, color: const Color(0xFF009900)),
            SizedBox(width: 10),
            Text('Ayudar', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD0EAFF),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          Accordion(
            scaleWhenAnimating: false,
            headerBackgroundColor: Colors.white,
            contentBorderWidth: 0,
            paddingBetweenClosedSections: 25,
            paddingBetweenOpenSections: 25,
            headerPadding: EdgeInsets.only(left: 18, bottom: 15, top: 15),
            contentHorizontalPadding: 18,
            contentVerticalPadding: 20,
            paddingListHorizontal: 0,
            rightIcon: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 35,
                color: Colors.black,
              ),
            ),
            children: [
              AccordionSection(
                header: Text(
                  'La app tiene problemas? Contactános',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                content: Column(
                  spacing: 20,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, color: const Color(0xFF009900)),
                        SizedBox(width: 15),
                        Text('loftech@uchile.cl'),
                      ],
                    ),
                  ],
                ),
              ),
              AccordionSection(
                header: Text(
                  'Acerca de la app',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                content: Text('...'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
