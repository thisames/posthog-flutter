import 'package:flutter/material.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_data.dart';
import 'package:posthog_flutter/src/screenshot/mask/element_data_factory.dart';
import 'package:posthog_flutter/src/screenshot/mask/element_object_parser.dart';
import 'package:posthog_flutter/src/screenshot/mask/root_element_provider.dart';

class WidgetElementsDecipher {
  late ElementData rootElementData;

  final ElementDataFactory _elementDataFactory;
  final ElementObjectParser _elementObjectParser;
  final RootElementProvider _rootElementProvider;

  WidgetElementsDecipher({
    required ElementDataFactory elementDataFactory,
    required ElementObjectParser elementObjectParser,
    required RootElementProvider rootElementProvider,
  })  : _elementDataFactory = elementDataFactory,
        _elementObjectParser = elementObjectParser,
        _rootElementProvider = rootElementProvider;

  ElementData? parseRenderTree(
    BuildContext context,
  ) {
    final rootElement = _rootElementProvider.getRootElement(context);
    if (rootElement == null) return null;

    final rootElementData = _elementDataFactory.createFromElement(rootElement, "Root");
    if (rootElementData == null) return null;

    this.rootElementData = rootElementData;

    _parseAllElements(
      this.rootElementData,
      rootElement,
    );

    return this.rootElementData;
  }

  void _parseAllElements(
    ElementData activeElementData,
    Element element,
  ) {
    ElementData? newElementData = _elementObjectParser.relateRenderObject(activeElementData, element);

    element.debugVisitOnstageChildren((childElement) {
      _parseAllElements(
        newElementData ?? activeElementData,
        childElement,
      );
    });
  }
}