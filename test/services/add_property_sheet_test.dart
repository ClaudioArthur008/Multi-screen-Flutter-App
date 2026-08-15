import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/models/property/property_model.dart';
import 'package:flutter_app/services/add_property_sheet.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const errorMessage =
      'Veuillez renseigner au moins un titre et un prix valide.';

  Future<void> prepareScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pump();
  }

  Future<void> tapSaveButton(WidgetTester tester) async {
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final buttonFinder = find.byKey(const Key('add_property_save_button'));

    await tester.dragUntilVisible(
      buttonFinder,
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );

    await tester.pumpAndSettle();
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
  }

  testWidgets('affiche une erreur si le titre est vide', (tester) async {
    await prepareScreen(tester);

    Map<String, dynamic>? captured;

    await tester.pumpWidget(
      wrap(AddPropertySheet(onAdd: (data) => captured = data)),
    );

    await tester.enterText(
      find.byKey(const Key('add_property_price_field')),
      '150000',
    );

    await tapSaveButton(tester);

    expect(find.text(errorMessage), findsOneWidget);
    expect(captured, isNull);
  });

  testWidgets('affiche une erreur si le prix est invalide ou nul', (
    tester,
  ) async {
    await prepareScreen(tester);

    Map<String, dynamic>? captured;

    await tester.pumpWidget(
      wrap(AddPropertySheet(onAdd: (data) => captured = data)),
    );

    await tester.enterText(
      find.byKey(const Key('add_property_designation_field')),
      'Studio Centre-ville',
    );

    await tapSaveButton(tester);

    expect(find.text(errorMessage), findsOneWidget);
    expect(captured, isNull);
  });

  testWidgets('affiche une erreur si le prix est négatif ou à zéro', (
    tester,
  ) async {
    await prepareScreen(tester);

    await tester.pumpWidget(wrap(const AddPropertySheet()));

    await tester.enterText(
      find.byKey(const Key('add_property_designation_field')),
      'Studio Centre-ville',
    );

    await tester.enterText(
      find.byKey(const Key('add_property_price_field')),
      '0',
    );

    await tapSaveButton(tester);

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets(
    'appelle onAdd avec les bonnes données quand le formulaire est valide',
    (tester) async {
      await prepareScreen(tester);

      Map<String, dynamic>? captured;

      await tester.pumpWidget(
        wrap(AddPropertySheet(onAdd: (data) => captured = data)),
      );

      await tester.enterText(
        find.byKey(const Key('add_property_designation_field')),
        'Studio Centre-ville',
      );

      await tester.enterText(
        find.byKey(const Key('add_property_price_field')),
        '250000',
      );

      await tester.enterText(
        find.byKey(const Key('add_property_location_field')),
        'Antananarivo',
      );

      await tapSaveButton(tester);

      expect(captured, isNotNull);
      expect(captured!['designation'], 'Studio Centre-ville');
      expect(captured!['price'], 250000.0);
      expect(captured!['location'], 'Antananarivo');
      expect(captured!['type'], PropertyType.apartment);
      expect(captured!['mode'], RentalMode.individual);
      expect(find.text(errorMessage), findsNothing);
    },
  );

  testWidgets('changer le dropdown de type met à jour la sélection', (
    tester,
  ) async {
    await prepareScreen(tester);

    Map<String, dynamic>? captured;

    await tester.pumpWidget(
      wrap(AddPropertySheet(onAdd: (data) => captured = data)),
    );

    final secondType = PropertyType.values[1];

    final dropdownFinder = find.byKey(const Key('add_property_type_dropdown'));

    await tester.dragUntilVisible(
      dropdownFinder,
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );

    await tester.pumpAndSettle();

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text(secondType.name).last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('add_property_designation_field')),
      'Villa avec jardin',
    );

    await tester.enterText(
      find.byKey(const Key('add_property_price_field')),
      '800000',
    );

    await tapSaveButton(tester);

    expect(captured, isNotNull);
    expect(captured!['type'], secondType);
  });
}
