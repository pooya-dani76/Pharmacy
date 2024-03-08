import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.onEditTap,
    this.onDeleteTap,
    this.subtitle,
  });

  final Widget title;
  final Widget? subtitle;
  final Function onTap;
  final Function? onEditTap;
  final Function? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          ListTile(
            title: title,
            subtitle: subtitle,
            onTap: () => onTap(),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (onDeleteTap != null) ...{
                IconButton(onPressed: () => onDeleteTap!(), icon: const Icon(Icons.delete)),
              },
              if (onEditTap != null) ...{
                IconButton(onPressed: () => onEditTap!(), icon: const Icon(Icons.edit)),
              }
            ]),
          ),
          const Divider(indent: 20, endIndent: 20),
        ],
      ),
    );
  }
}
