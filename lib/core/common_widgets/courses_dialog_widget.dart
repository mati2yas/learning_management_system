part of 'course_card_network.dart';

class PricesDialogWidget extends StatefulWidget {
  final Course course;
  const PricesDialogWidget({
    super.key,
    required this.course,
  });

  @override
  State<PricesDialogWidget> createState() => _PricesDialogWidgetState();
}

class PriceTypeIndicator extends StatelessWidget {
  final String text;
  final bool contentRevealed;
  final Function onTapCallback;
  const PriceTypeIndicator({
    super.key,
    required this.contentRevealed,
    required this.onTapCallback,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCallback();
      },
      child: Row(
        spacing: 4,
        children: [
          Text(text),
          Icon(
            contentRevealed ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          ),
        ],
      ),
    );
  }
}

class RichTextFormat extends StatelessWidget {
  final String normalPrice;
  final String? onsalePrice;
  const RichTextFormat({
    super.key,
    required this.normalPrice,
    required this.onsalePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text.rich(
          textDirection: TextDirection.ltr,
          TextSpan(
            children: [
              const TextSpan(
                text: 'Original: ',
                style: TextStyle(
                  color: AppColors.mainBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: normalPrice,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (onsalePrice != null) ...[
                const TextSpan(
                  text: "Onsale: ",
                  style: TextStyle(
                    color: AppColors.mainBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: onsalePrice,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _PricesDialogWidgetState extends State<PricesDialogWidget> {
  bool oneMonthRevealed = false,
      threeMonthRevealed = false,
      sixMonthRevealed = false,
      yearlyRevealed = false;
  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          const Text("Prices: On sale and normal"),
          PriceTypeIndicator(
              contentRevealed: oneMonthRevealed,
              onTapCallback: () {
                setState(() {
                  oneMonthRevealed = !oneMonthRevealed;
                });
              },
              text: "One Month"),
          if (oneMonthRevealed)
            RichTextFormat(
              normalPrice: normalToString(SubscriptionType.oneMonth),
              onsalePrice: onSaleToString(SubscriptionType.oneMonth),
            ),
          PriceTypeIndicator(
            text: "Three Months",
            contentRevealed: threeMonthRevealed,
            onTapCallback: () {
              setState(() {
                threeMonthRevealed = !threeMonthRevealed;
              });
            },
          ),
          if (threeMonthRevealed)
            RichTextFormat(
              normalPrice: normalToString(SubscriptionType.threeMonths),
              onsalePrice: onSaleToString(SubscriptionType.threeMonths),
            ),
          PriceTypeIndicator(
            text: "Six Months",
            contentRevealed: sixMonthRevealed,
            onTapCallback: () {
              setState(() {
                sixMonthRevealed = !sixMonthRevealed;
              });
            },
          ),
          if (sixMonthRevealed)
            RichTextFormat(
              normalPrice: normalToString(SubscriptionType.sixMonths),
              onsalePrice: onSaleToString(SubscriptionType.sixMonths),
            ),
          PriceTypeIndicator(
            text: "Yearly",
            contentRevealed: yearlyRevealed,
            onTapCallback: () {
              setState(() {
                yearlyRevealed = !yearlyRevealed;
              });
            },
          ),
          if (yearlyRevealed)
            RichTextFormat(
              normalPrice: normalToString(SubscriptionType.yearly),
              onsalePrice: onSaleToString(SubscriptionType.yearly),
            ),
        ],
      ),
    );
  }

  String normalToString(SubscriptionType subType) {
    if (widget.course.price[subType] == null) {
      return "Not Available";
    }
    String val = (widget.course.price[subType] ?? 0.00).toStringAsFixed(2);
    return "$val  ";
  }

  String? onSaleToString(SubscriptionType subType) {
    if (widget.course.onSalePrices[subType] == null) {
      return null;
    }
    return (widget.course.onSalePrices[subType] ?? 0.00).toStringAsFixed(2);
  }
}
