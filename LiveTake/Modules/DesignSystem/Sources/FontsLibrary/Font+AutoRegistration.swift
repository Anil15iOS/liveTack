import Foundation
import UIKit

public typealias FontNameExt = (name: String, ext: String)

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}

public let fontsToRegister = [
  FontNameExt(name: "DIN Condensed Bold", ext: "ttf")
]

public func autoRegisteringFont(_ fontNames: [FontNameExt] = fontsToRegister, _ spmBundleName: String = "DesignSystem_FontsLibrary") throws {
  guard let spmBundle = Bundle(bundleName: spmBundleName) else {
    throw "Fail to find bundle(\(spmBundleName).bundle) in your app bundle."
  }
  try fontURLs(for: fontNames, in: spmBundle).forEach { try registerFont(from: $0) }
}

extension Bundle {
  convenience init?(bundleName: String) {
    self.init(path: "\(Bundle.main.bundlePath)/\(bundleName).bundle")
  }
}

func fontURLs(for fontNames: [FontNameExt], in bundle: Bundle) -> [URL] {
  return fontNames.compactMap { police in
    bundle.url(forResource: police.name, withExtension: police.ext)
  }
}

func registerFont(from url: URL) throws {
  guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
    throw "Could not get reference to font data provider."
  }
  guard let font = CGFont(fontDataProvider) else {
    throw "Could not get font from CoreGraphics."
  }
  var error: Unmanaged<CFError>?
  guard CTFontManagerRegisterGraphicsFont(font, &error) else {
    throw "Error registering font: \(dump(error))."
  }
}
