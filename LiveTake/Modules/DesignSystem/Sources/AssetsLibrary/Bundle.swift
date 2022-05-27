import SwiftUI
import Utility

public func livetakeImage(name: String) -> Image {
  Image(name, bundle: .bundle(for: CurrentBundleFinder.self, in: "DesignSystem_AssetsLibrary"))
}

private class CurrentBundleFinder {}
