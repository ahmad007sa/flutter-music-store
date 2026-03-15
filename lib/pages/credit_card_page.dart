import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:uuid/uuid.dart';

import 'package:musicstore/models/invoice.dart';
import 'package:musicstore/pages/buying_succeeded.dart';
import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/models/order.dart';

Uuid uuid = const Uuid();

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({super.key});

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          CreditCardWidget(
            enableFloatingCard: useFloatingAnimation,
            glassmorphismConfig: _getGlassmorphismConfig(),
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            bankName: 'Axis Bank',
            frontCardBorder:
                useGlassMorphism ? null : Border.all(color: Colors.grey),
            backCardBorder:
                useGlassMorphism ? null : Border.all(color: Colors.grey),
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            customCardTypeIcons: <CustomCardTypeIcon>[
              CustomCardTypeIcon(
                cardType: CardType.mastercard,
                cardImage: Image.asset(
                  'images/mastercard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    inputConfiguration: const InputConfiguration(
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: InputDecoration(
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        labelText: 'Card Holder',
                      ),
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _onValidate,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: const Text(
                        'Validate',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'halter',
                          fontSize: 14,
                          package: 'flutter_credit_card',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      invoice = Invoice(
          date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
          creditCard: cardNumber,
          total: total,
          customerId: currentUser.customerId,
          inVoiceId: uuid.v4());

      for (var item in cart) {
        orders.add(
          OrderT(
            inVoiceId: invoice.inVoiceId,
            songId: item.songId,
            orderId: uuid.v4(),
          ),
        );
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return const BuyingSucceeded();
          },
        ),
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }
}
