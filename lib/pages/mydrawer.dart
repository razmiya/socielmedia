import 'package:flutter/material.dart';
import 'package:socielmedia/components/mylisttile.dart';
class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onChatTap;
  final void Function()? onSignOut;
  const MyDrawer({super.key,
  required this.onProfileTap,
    required this.onChatTap,
  required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //header
         DrawerHeader(
             child: Icon(Icons.person,
               color: Colors.white,
               size: 65,
             ),
         ),
          //home list tile
          MyListTile(icon: Icons.home, text: "H O M E",
          onTap: () => Navigator.pop(context),
          ),
          //profile list tile
            MyListTile(icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap),
          MyListTile(icon: Icons.message,
              text: "C H A T",
              onTap: onChatTap),
          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: MyListTile(icon: Icons.person,
                text: "L O G O U T",
                onTap: onSignOut),
          ),
        ],
      ),
    );
  }
}
