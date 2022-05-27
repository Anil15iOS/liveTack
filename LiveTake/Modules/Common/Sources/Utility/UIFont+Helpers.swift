import UIKit

public extension UIFont {
  var ultraLight: UIFont { return withWeight(.ultraLight) }
  var thin: UIFont { return withWeight(.thin) }
  var light: UIFont { return withWeight(.light) }
  var regular: UIFont { return withWeight(.regular) }
  var medium: UIFont { return withWeight(.medium) }
  var semibold: UIFont { return withWeight(.semibold) }
  var bold: UIFont { return withWeight(.bold) }
  var black: UIFont { return withWeight(.black) }

  private func withWeight(_ weight: UIFont.Weight) -> UIFont {
    var attributes = fontDescriptor.fontAttributes
    var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

    traits[.weight] = weight

    attributes[.name] = nil
    attributes[.traits] = traits
    attributes[.family] = familyName

    let descriptor = UIFontDescriptor(fontAttributes: attributes)

    return UIFont(descriptor: descriptor, size: pointSize)
  }
}
