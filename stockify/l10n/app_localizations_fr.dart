// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'StockiFy';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get products => 'Produits';

  @override
  String get orders => 'Commandes';

  @override
  String get analytics => 'Analyses';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get addProduct => 'Ajouter un produit';

  @override
  String get editProduct => 'Modifier le produit';

  @override
  String get deleteProduct => 'Supprimer le produit';

  @override
  String get productName => 'Nom du produit';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Code-barres';

  @override
  String get description => 'Description';

  @override
  String get costPrice => 'Prix de revient';

  @override
  String get sellingPrice => 'Prix de vente';

  @override
  String get stockQuantity => 'Quantité en stock';

  @override
  String get lowStockThreshold => 'Seuil de stock faible';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get image => 'Image';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get view => 'Voir';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get totalRevenue => 'Revenu total';

  @override
  String get totalOrders => 'Total des commandes';

  @override
  String get totalProducts => 'Total des produits';

  @override
  String get averageOrderValue => 'Valeur moyenne de commande';

  @override
  String get lowStockCount => 'Nombre de stocks faibles';

  @override
  String get revenueTrends => 'Tendances des revenus';

  @override
  String get topSellingProducts => 'Produits les plus vendus';

  @override
  String get lowStockAlerts => 'Alertes de stock faible';

  @override
  String get recentActivities => 'Activités récentes';

  @override
  String get newSale => 'Nouvelle vente';

  @override
  String get orderNumber => 'Numéro de commande';

  @override
  String get orderDate => 'Date de commande';

  @override
  String get orderStatus => 'Statut de la commande';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get completed => 'Terminé';

  @override
  String get refunded => 'Remboursé';

  @override
  String get cash => 'Espèces';

  @override
  String get card => 'Carte';

  @override
  String get notifications => 'Notifications';

  @override
  String get subscription => 'Abonnement';

  @override
  String get billing => 'Facturation';

  @override
  String get help => 'Aide';

  @override
  String get privacy => 'Politique de confidentialité';

  @override
  String get language => 'Langue';

  @override
  String get logout => 'Déconnexion';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get update => 'Mettre à jour';

  @override
  String get viewAll => 'Voir tout';

  @override
  String unitsSold(int count) {
    return '$count unités vendues';
  }

  @override
  String onlyLeft(int count) {
    return 'Il ne reste que $count';
  }

  @override
  String get outOfStock => 'Rupture de stock';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String pleaseEnter(String field) {
    return 'Veuillez entrer $field';
  }

  @override
  String get invalidEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String languageChanged(String language) {
    return 'Langue changée en $language';
  }
}
