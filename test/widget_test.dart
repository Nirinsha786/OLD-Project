import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image2pdf_easyconvert/main.dart';

void main() {
  testWidgets('Image to PDF Converter Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const Image2PDFEasyConvert());

    // Verify that the initial screen title is displayed.
    expect(find.text('Image to PDF Converter'), findsOneWidget);

    // Tap on the "Pick Images from Gallery" button.
    await tester
        .tap(find.widgetWithText(MaterialButton, 'Pick Images from Gallery'));
    await tester.pump();

    // Check if we are navigated to the selected images screen.
    expect(find.text('Selected Images'), findsOneWidget);

    // Add a mock image path to the images list.
    final imageListFinder = find.byType(GridView);
    expect(imageListFinder, findsOneWidget);
    expect(find.byType(Image), findsNothing); // No images initially

    // Mock adding an image
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Check if an image is added to the list
    expect(find.byType(Image), findsOneWidget);

    // Tap on "Convert" button
    await tester.tap(find.widgetWithText(MaterialButton, 'Convert'));
    await tester.pump();

    // Check if the exporting progress is shown
    expect(find.text('Exporting'), findsOneWidget);

    // Wait for conversion process (mocked here)
    await tester.pump(const Duration(seconds: 3));

    // Check if the success dialog appears after conversion
    expect(find.text('PDF Saved'), findsOneWidget);

    // Tap on OK button in the success dialog
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pump();

    // Verify if navigated back to the main page
    expect(find.text('Image to PDF Converter'), findsOneWidget);
  });
}
