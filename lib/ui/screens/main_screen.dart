import 'package:es_calc/models/screen.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:es_calc/providers/shopping_list_provider.dart';
import 'package:es_calc/ui/screens/compare_prices.dart';
import 'package:es_calc/ui/screens/settings.dart';
import 'package:es_calc/ui/screens/shopping_cart.dart';
import 'package:es_calc/ui/screens/shopping_list.dart';
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
  int _currentNavigationIndex = 0;
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final stateNotifier = ref.watch(shoppingListProvider.notifier);

    final screens = [
      Screen(
        screen: ShoppingCartScreen(listKey: _listKey),
        title: const Text('Shopping Cart'),
      ),
      Screen(
        screen: const ShoppingListScreen(),
        title: const Text('Shopping List Manager'),
      ),
      null,
      Screen(
        screen: const CompareScreen(),
        title: const Text('Compare Prices'),
      ),
      Screen(
        screen: const SettingsScreen(),
        title: const Text('Settings'),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: screens[_currentNavigationIndex]!.title,
        centerTitle: true,
      ),
      body: screens[_currentNavigationIndex]!.screen,
      floatingActionButton:
          _currentNavigationIndex == 0 || _currentNavigationIndex == 1
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 7, 97, 143),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final newItem = await showDialog<ShoppingItem>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return ProductDialog(
                            item: ShoppingItem(),
                            title: 'Add to Cart',
                          );
                        });
                    if (newItem != null) {
                      final newIndex = await stateNotifier.addItem(newItem);
                      _listKey.currentState!.insertItem(newIndex);
                    }
                  },
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        notchMargin: 4,
        color: const Color.fromARGB(255, 246, 242, 96),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 24,
              onPressed: () {
                setState(() {
                  _currentNavigationIndex = 0;
                });
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            IconButton(
              splashRadius: 24,
              onPressed: () {
                setState(() {
                  _currentNavigationIndex = 1;
                });
              },
              icon: const Icon(Icons.list_outlined),
            ),
            const SizedBox(),
            IconButton(
              splashRadius: 24,
              onPressed: () {
                setState(() {
                  _currentNavigationIndex = 3;
                });
              },
              icon: const Icon(Icons.compare_arrows_outlined),
            ),
            IconButton(
              splashRadius: 24,
              onPressed: () {
                setState(() {
                  _currentNavigationIndex = 4;
                });
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
