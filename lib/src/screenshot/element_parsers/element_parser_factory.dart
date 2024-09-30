import 'package:flutter/rendering.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/element_parser.dart';
import 'package:posthog_flutter/src/screenshot/element_parsers/render_image_parser.dart';

import 'position_calculator.dart';
import 'scaler.dart';

abstract class ElementParserFactory {
  ElementParser createElementParser(Type type);
}

class DefaultElementParserFactory implements ElementParserFactory {
  @override
  ElementParser createElementParser(Type type) {
    if (type == RenderImage) {
      return RenderImageParser(
        scaler: ImageScaler(),
        positionCalculator: DefaultPositionCalculator(),
      );
    } else if (type == RenderParagraph || type == RenderTransform) {
      return ElementParser();
    }

    // Default fallback
    return ElementParser();
  }
}