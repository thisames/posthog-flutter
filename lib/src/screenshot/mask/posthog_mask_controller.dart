import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_data.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_parser.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_parser_factory.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_parsers_const.dart';
import 'package:posthog_flutter/src/screenshot/mask/element_data_factory.dart';
import 'package:posthog_flutter/src/screenshot/mask/element_object_parser.dart';
import 'package:posthog_flutter/src/screenshot/mask/root_element_provider.dart';
import 'package:posthog_flutter/src/screenshot/mask/widget_elements_decipher.dart';

class PostHogMaskController {
  late final Map<String, ElementParser> parsers;

  final GlobalKey containerKey = GlobalKey();

  final WidgetElementsDecipher _widgetScraper;

  PostHogMaskController._privateConstructor()
      : _widgetScraper = WidgetElementsDecipher(
          elementDataFactory: ElementDataFactory(),
          elementObjectParser: ElementObjectParser(),
          rootElementProvider: RootElementProvider(),
        ) {
    parsers = ElementParsersConst(DefaultElementParserFactory()).parsersMap;
  }

  static final PostHogMaskController instance = PostHogMaskController._privateConstructor();

  Future<ElementData?> getElementMaskTree() async {
    final BuildContext? context = containerKey.currentContext;

    if (context == null) {
      return null;
    }
    return _widgetScraper.parseRenderTree(context);
  }
}