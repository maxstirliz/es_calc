import 'package:es_calc/models/screen.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/screens/compare_prices.dart';
import 'package:es_calc/ui/screens/settings.dart';
import 'package:es_calc/ui/screens/shopping_cart.dart';
import 'package:es_calc/ui/screens/shopping_list.dart';
import 'package:es_calc/ui/widgets/add_item_dialog.dart';
import 'package:es_calc/ui/widgets/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentNavigationIndex = 0;

  final List<Screen?> _screens = [
    Screen(
        screen: const ShoppingCartScreen(), title: const Text('Shopping Cart')),
    Screen(
        screen: const ShoppingListScreen(), title: const Text('Shopping List')),
    null,
    Screen(screen: const CompareScreen(), title: const Text('Compare Prices')),
    Screen(screen: const SettingsScreen(), title: const Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: _screens[currentNavigationIndex]!.title,
        centerTitle: true,
      ),
      body: _screens[currentNavigationIndex]!.screen,
      floatingActionButton:
          currentNavigationIndex == 0 || currentNavigationIndex == 1
              ? FloatingActionButton(
                  backgroundColor: const Color.fromARGB(250, 145, 232, 252),
                  onPressed: () async {
                    if (currentNavigationIndex == 0) {
                      final updatedItem = await showDialog<ShoppingItem>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return ProductDialog(
                              item: ShoppingItem(),
                              title: 'Add Product',
                            );
                          });
                      if (updatedItem != null) {
                        stateNotifier.addItem(updatedItem);
                      }
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return const AddItemDialog();
                          });
                    }
                  },
                  child: const Icon(Icons.add),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: const Color.fromARGB(255, 229, 252, 231),
        selectedIndex: currentNavigationIndex,
        backgroundColor: const Color.fromARGB(255, 250, 247, 119),
        onDestinationSelected: (index) {
          setState(() {
            currentNavigationIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            label: 'List',
          ),
          SizedBox(),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_outlined),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
