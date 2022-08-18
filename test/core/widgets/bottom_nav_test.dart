
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherBs/core/widgets/bottom_nav.dart';

void main() {

  testWidgets('2 IconButton in bottom nav should be Exist', (tester) async {
    // Widget childWidget = IconButton(icon: const Icon(Icons.home), onPressed: () {  },);
    await tester.pumpWidget(MaterialApp(home: Scaffold(
        bottomNavigationBar: BottomNav(Controller: PageController()),
      ),
    ));

    final homeIconButton = find.byIcon(Icons.home,);
    final bookmarkIconButton = find.byIcon(Icons.bookmark,);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(homeIconButton, findsOneWidget);
    expect(bookmarkIconButton, findsOneWidget);
  });

  testWidgets('click IconButton in bottom nav should moving to page 0 in pageView', (tester) async {

    /// build widget
    PageController pageController = PageController();
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      bottomNavigationBar: BottomNav(Controller: pageController),
      body: PageView(
        controller: pageController,
        children: [
          Container(),
          Container()
        ],
        // physics: const NeverScrollableScrollPhysics(),
      ),),));

    /// Tap the Icon button.
    await tester.tap(find.widgetWithIcon(IconButton, Icons.home));

    /// Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();

    /// Expect to move to home screen.
    expect(pageController.page, 0);
  });

  testWidgets('click IconButton in bottom nav should moving to page 1 in pageView', (tester) async {

    /// build widget
    PageController pageController = PageController();
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      bottomNavigationBar: BottomNav(Controller: pageController),
      body: PageView(
        controller: pageController,
        children: [
          Container(),
          Container()
        ],
        // physics: const NeverScrollableScrollPhysics(),
      ),),));

    /// Tap the Icon button.
    await tester.tap(find.widgetWithIcon(IconButton, Icons.bookmark));

    print("pageController : " + pageController.page.toString());

    /// Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();

    /// Expect to move to home screen.
    expect(pageController.page, 1);
  });
}