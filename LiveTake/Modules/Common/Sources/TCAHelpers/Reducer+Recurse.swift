import Foundation
import ComposableArchitecture

public extension Reducer {
  static func recurse(_ reducer: @escaping (Reducer, inout State, Action, Environment) -> Effect<Action, Never>) -> Reducer {
    // swiftlint:disable implicitly_unwrapped_optional
    var `self`: Reducer!
    // swiftlint:enable implicitly_unwrapped_optional
    self = Reducer { state, action, environment in
      reducer(self, &state, action, environment)
    }
    return self
  }
}
