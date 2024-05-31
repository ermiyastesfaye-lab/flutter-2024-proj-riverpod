import 'package:agri_app_2/order/presentation/order_display.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userRole;

  const AppBarWidget({super.key, required this.userRole});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AgriConnect',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: myColor.tertiary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => OrderDisplayScreen()),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: themeProvider.getTheme == darkTheme
                      ? Colors.white
                      : const Color.fromARGB(255, 103, 103, 103),
                ),
                label: const Text(''),
              )
            ],
          ),
        );
      },
    );
  }
}
