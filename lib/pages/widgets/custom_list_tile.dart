import 'package:flutter/material.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.onEditTap,
    this.onDeleteTap,
    this.subtitle,
    required this.index,
  });

  final Widget title;
  final Widget? subtitle;
  final Function onTap;
  final Function? onEditTap;
  final Function? onDeleteTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          ListTile(
            title: Wrap(
              children: [
                CustomText(
                  text: '$index- ',
                  fontWeight: FontWeight.bold,
                ),
                title
              ],
            ),
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
