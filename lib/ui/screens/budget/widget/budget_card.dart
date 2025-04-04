// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tourism_app/theme/theme.dart';

class BudgetCard extends StatelessWidget {
  final String title;
  final double spent;
  final double budget;
  final String currency;
  final String? subtitle;

  const BudgetCard({
    super.key,
    required this.title,
    required this.spent,
    required this.budget,
    required this.currency,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(  // Changed from Expanded to Flexible to avoid layout issues
      child: Card(
        color: title == "Daily Budget" 
            ? DertamColors.blueSky
            : DertamColors.greyLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DertamSpacings.radius),
        ),
        child: Padding(
          padding: EdgeInsets.all(DertamSpacings.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Ensures the card takes minimal height
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: DertamTextStyles.body),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10,
                        color: DertamColors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8), // Standard spacing for consistency
              Text(
                '$currency ${spent.toStringAsFixed(0)}',
                style: DertamTextStyles.title,
              ),
              const SizedBox(height: 4),
              Text(
                '${spent.toStringAsFixed(0)}/${budget.toStringAsFixed(0)}',
                style: DertamTextStyles.label.copyWith(
                  color: DertamColors.grey,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0,
                backgroundColor: DertamColors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  spent > budget ? DertamColors.red : DertamColors.primary,
                ),
                minHeight: spent > budget ? 2 : null, // Make the line slightly thicker when over budget
              ),
            ],
          ),
        ),
      ),
    );
  }
}