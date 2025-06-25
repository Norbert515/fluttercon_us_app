import 'package:flutter/material.dart';
import '../../../../shared/models/models.dart';

class SpeakerCard extends StatelessWidget {
  final Speaker speaker;
  final VoidCallback? onTap;

  const SpeakerCard({super.key, required this.speaker, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child:
                    speaker.profilePicture.isNotEmpty
                        ? Image.network(
                          speaker.profilePicture,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 48, color: Colors.grey);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        )
                        : const Icon(Icons.person, size: 48, color: Colors.grey),
              ),

              // Speaker Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        speaker.fullName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (speaker.tagLine.isNotEmpty)
                        Text(
                          speaker.tagLine,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Top Speaker Badge
                      if (speaker.isTopSpeaker && false) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'Top Speaker',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
