import Foundation

extension Foundation.Bundle {
  public static func bundle<T: AnyObject>(for finder: T.Type, in bundleName: String) -> Bundle {
    let candidates = [
      /* Bundle should be present here when the package is linked into an App. */
      Bundle.main.resourceURL,
      /* Bundle should be present here when the package is linked into a framework. */
      Bundle(for: finder).resourceURL,
      /* Bundle should be present here when the package is used in UI Tests. */
      Bundle(for: finder).resourceURL?.deletingLastPathComponent(),
      /* For command-line tools. */
      Bundle.main.bundleURL,
      /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
      Bundle(for: finder).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
      Bundle(for: finder).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
    ]

    for candidate in candidates {
      let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
      if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }
    fatalError("unable to find bundle")
  }
}
