import 'package:flutter/material.dart';
import 'package:vollgym/app/models/account_tile_data.dart';

class AccountCategoryItems extends StatelessWidget {
  const AccountCategoryItems({
    super.key,
    this.title,
    required this.items,
  });

  final String? title;
  final List<AccountTileData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(title!, style: TextStyle(fontSize: 15)),
          ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: List.generate(
              items.length,
              (i) {
                if (items.length > 1 && i != (items.length - 1)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTile(context, i),
                        Divider(
                          height: 2,
                          thickness: 1.2,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTile(context, i),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, int i) {
    return Row(
      children: [
        Icon(items[i].icon),
        const SizedBox(width: 5),
        TextButton(
          onPressed: () => items[i].onPressed(),
          child: Text(items[i].title),
        ),
      ],
    );
  }
}
