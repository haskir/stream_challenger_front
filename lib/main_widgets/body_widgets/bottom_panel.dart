import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPanel extends StatelessWidget implements PreferredSizeWidget {
  static const String copyrightText =
      "Copyright ©2k54 StreamChallenge. All rights reserved. Terms of service Privacy Policy Copyright Cookies Policy";
  static const String discord = "images/svg_logos/discord_logo.svg";
  static const String discordPathInvite = "https://discord.gg/58PYnXeeWK";
  late final Uri discordUri;
  static const String telegram = "images/svg_logos/telegram_logo.svg";
  static const String telegramPathInvite = "https://t.me/lapki_na_stol";
  late final Uri telegramUri;

  BottomPanel({super.key})
      : discordUri = Uri.parse(discordPathInvite),
        telegramUri = Uri.parse(telegramPathInvite);

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
            child: Text(
              copyrightText,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Right side (Icons)
          Row(
            children: [
              IconButton(
                onPressed: () => launchUrl(telegramUri),
                icon: SvgPicture.asset(telegram, height: 25),
              ),
              IconButton(
                onPressed: () => launchUrl(discordUri),
                icon: SvgPicture.asset(discord, height: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
