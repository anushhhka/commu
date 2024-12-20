import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedTile extends StatelessWidget {
  const FeedTile({
    super.key,
    this.text,
    this.image,
    this.createdAt,
  });

  final String? text, image;
  final Timestamp? createdAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/png/logo.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nana Asambia',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (createdAt != null)
                    Text(
                      timeago.format(
                        createdAt!.toDate(),
                        locale: 'en',
                      ),
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (text != null) Text(text!, textAlign: TextAlign.left, style: Typo.bodyLarge),
          const SizedBox(height: 10),
          if (image != null)
            AspectRatio(
              aspectRatio: 16 / 11,
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: Image.network(
                  image!,
                ),
              ),
            )
        ],
      ),
    );
  }
}
