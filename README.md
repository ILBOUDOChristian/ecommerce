# Shoply — E-commerce Flutter + Riverpod

Application e-commerce Flutter démontrant un state management **Riverpod 2.x** (`StateNotifierProvider`, `FutureProvider`, `Provider`, `AsyncValue`) avec une architecture en couches.

## Fonctionnalités

- Catalogue produits (liste + fiche détail)
- Panier : ajout, suppression, quantité, total
- Favoris persistés localement (`SharedPreferences`)
- Filtrage (catégorie, recherche, stock) et tri (prix, nom, note)
- Profil utilisateur mocké
- États de chargement / erreur dans l’UI via `AsyncValue`
- Bonus : animation de vol vers l’icône panier + badge animé

## Architecture

```
lib/
  core/theme/                 # thème Material 3
  data/
    models/                   # Product, CartItem, CatalogFilter, UserProfile
    repositories/             # accès données (JSON local, prefs, mock profil)
  presentation/
    providers/                # logique métier / état (Riverpod)
    screens/                  # UI
    widgets/                  # composants réutilisables
assets/data/products.json     # catalogue mock
```

Les widgets **ne parlent pas** aux sources de données. Ils consomment des providers ; les repositories encapsulent JSON, délai simulé et persistance.

| Couche | Rôle |
| --- | --- |
| `data/models` | Entités immuables |
| `data/repositories` | I/O (asset JSON, SharedPreferences, mock) |
| `presentation/providers` | État, règles métier, composition |
| `presentation/screens` | UI + `ref.watch` / `ref.read` |

## Providers

| Provider | Type | Rôle |
| --- | --- | --- |
| `productRepositoryProvider` | `Provider` | Injection du repository catalogue |
| `favoritesRepositoryProvider` | `Provider` | Injection du repository favoris |
| `profileRepositoryProvider` | `Provider` | Injection du repository profil |
| `productsProvider` | `FutureProvider` | Charge le JSON (loading / data / error) |
| `productByIdProvider` | `FutureProvider.family` | Détail d’un produit |
| `categoriesProvider` | `Provider` | Catégories dérivées du catalogue |
| `catalogFilterProvider` | `StateNotifierProvider` | Recherche, catégorie, tri, stock |
| `filteredProductsProvider` | `Provider` | Liste filtrée / triée (`AsyncValue`) |
| `cartProvider` | `StateNotifierProvider` | Lignes du panier |
| `cartItemCountProvider` | `Provider` | Nombre d’articles (badge) |
| `cartTotalProvider` | `Provider` | Montant total |
| `favoritesProvider` | `StateNotifierProvider<AsyncValue<Set<String>>>` | IDs favoris persistés |
| `isFavoriteProvider` | `Provider.family` | Un produit est-il favori ? |
| `favoriteProductsProvider` | `Provider` | Produits favoris (`AsyncValue`) |
| `profileProvider` | `FutureProvider` | Profil mock |
| `cartIconKeyProvider` | `Provider` | Clé de l’icône panier (animation) |

`AsyncValueWidget` centralise le rendu `loading` / `error` / `data` (avec bouton **Réessayer**).

## Lancer l’app

```bash
flutter pub get
flutter run
```

Les images produits sont chargées depuis un CDN (connexion Internet requise). Le catalogue lui-même est **local** (`assets/data/products.json`).

## Tests

```bash
flutter test
flutter analyze
```
