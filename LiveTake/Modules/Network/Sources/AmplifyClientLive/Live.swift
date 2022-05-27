import Amplify
import AmplifyClient
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Foundation

extension AmplifyClient {
  public static let live = Self(
    configure: .catching {
      // add the app auth plugin
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.add(plugin: AWSAPIPlugin())

      guard let url = Bundle.module.url(forResource: "amplifyconfiguration", withExtension: "json") else {
        throw ConfigurationError.amplifyAlreadyConfigured(
          "Could not load default `amplifyconfiguration.json` file",
          "Expected to find the file, `amplifyconfiguration.json` in the app bundle, but it was not present."
        )
      }

      let configuration = try AmplifyConfiguration(configurationFile: url)
      try Amplify.configure(configuration)
    }
      .handleEvents(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            print("✅ Amplify configured successfully")
          case .failure(let error):
            print("🚫 Amplify configuration failed: \(error)")
          }
        }
      )
      .eraseToEffect()
  )
}
