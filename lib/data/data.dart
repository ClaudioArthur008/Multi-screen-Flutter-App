import 'package:flutter_app/domain/models/property/property_model.dart';
import 'package:flutter_app/domain/models/user/user_model.dart';

abstract class MockData {
  // Utilisateur connecté par défaut
  static final User currentUser = User(
    id: 1,
    name: 'Claudio Arthur',
    email: 'claudio.lurann@gmail.com',
    password: '00000000',
    avatarUrl: null,
  );

  // Liste des propriétés / logements
  static final List<Property> properties = [
    Property(
      id: "AA1",
      designation: 'Villa Analamanga',
      description:
          'Superbe résidence spacieuse avec grand jardin et vue panoramique.',
      location: 'Ivato, Antananarivo',
      price: 1500000,
      type: PropertyType.residence,
      imageUrl: 'assets/images/campus.jfif',
    ),
    Property(
      id: 'AA2',
      designation: 'Studio Centre-Ville',
      description:
          'Chambre meublée avec kitchenette, idéale pour étudiant ou professionnel.',
      location: 'Ankatso, Antananarivo',
      price: 350000,
      type: PropertyType.room,
      imageUrl: 'assets/images/room.jfif',
    ),
    Property(
      id: 'AA3',
      designation: 'Appartement T3 Stand standing',
      description:
          'Appartement moderne, sécurisé 24/7 avec parking sous-terrain.',
      location: 'Isoraka, Antananarivo',
      price: 900000,
      type: PropertyType.apartment,
      imageUrl: 'assets/images/appart.jfif',
    ),
  ];
}
