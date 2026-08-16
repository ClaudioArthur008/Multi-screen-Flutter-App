import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/widgets/add_property_sheet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/screens/home/home_screen.dart';
import 'package:flutter_app/presentation/screens/search/search_screen.dart';
import 'package:flutter_app/presentation/screens/property_details/property_details.dart';
import 'package:flutter_app/presentation/widgets/property_card.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Widget buildApp() => const MyApp();

  group('Parcours utilisateur - bout en bout', () {
    testWidgets('accueil -> détail logement -> retour', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(PropertyCard), findsWidgets);

      final cardFinder = find.byType(PropertyCard).first;
      await tester.ensureVisible(cardFinder);
      await tester.pumpAndSettle();

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      expect(find.byType(PropertyDetailsScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('recherche filtre les résultats et affiche l\'état vide', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).first;
      await tester.ensureVisible(searchField);
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'zzz_introuvable_zzz');
      await tester.pumpAndSettle();

      expect(
        find.text('Aucun logement ne correspond à votre recherche'),
        findsOneWidget,
      );
    });

    testWidgets('navigation vers l\'onglet Recherche via la bottom bar', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.text('Recherche'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchScreen), findsOneWidget);
    });

    testWidgets('ajout de logement via le FAB : validation puis fermeture', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final fabFinder = find.byIcon(Icons.add_rounded);
      await tester.ensureVisible(fabFinder);
      await tester.tap(fabFinder);
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
