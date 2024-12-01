import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPanel extends StatelessWidget implements PreferredSizeWidget {
  static const String copyrightText =
      "Copyright ©2k54 StreamChallenge. All rights reserved.";
  static const String discord = "images/svg_logos/discord_logo.svg";
  static const String discordPathInvite = "https://discord.gg/58PYnXeeWK";
  static const String telegram = "images/svg_logos/telegram_logo.svg";
  static const String telegramPathInvite = "https://t.me/lapki_na_stol";

  const BottomPanel({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side (Copyright)
          Expanded(
            child: Row(
              children: [
                Text(
                  copyrightText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                TextButton(onPressed: () {}, child: Text("Terms of service")),
                Text(" | "),
                TextButton(onPressed: () {}, child: Text("Privacy Policy")),
                Text(" | "),
                TextButton(onPressed: () {}, child: Text("Copyright")),
                Text(" | "),
                TextButton(onPressed: () {}, child: Text("Cookie Policy")),
              ],
            ),
          ),
          // Right side (Icons)
          Row(
            children: [
              IconButton(
                onPressed: () => launchUrl(Uri.parse(telegramPathInvite)),
                icon: SvgPicture.asset(telegram, height: 25),
              ),
              IconButton(
                onPressed: () => launchUrl(Uri.parse(discordPathInvite)),
                icon: SvgPicture.asset(discord, height: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
