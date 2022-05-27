import Amplify
import AuthenticationClient
import AWSCognitoAuthPlugin
import Combine
import Foundation

extension AuthenticationClient {
  public static var live: AuthenticationClient {
    return Self(
      createUsername: { userName in
        // TODO: Check with verified user list
        return Amplify.Auth.update(userAttribute: .init(.preferredUsername, value: userName))
          .resultPublisher
          .map { result in
            print(result)
            return .createPassword
          }
          .mapError(AuthClientError.init(from:))
          .eraseToEffect()
      },

      deleteUser: {
        .future { callback in
          Amplify.Auth.deleteUser { result in
            switch result {
            case .success:
              callback(.success(()))
            case .failure(let error):
              callback(.failure(AuthClientError(from: error)))
            }
          }
        }
      },

      isSignedIn: {
        Amplify.Auth.fetchAuthSession()
          .resultPublisher
          .map(\.isSignedIn)
          .print()
          .removeDuplicates()
          .replaceError(with: false)
          .eraseToEffect()
      },

      isUsernameOnVerifiedList: { username in
        print(username)
        return .none
      },

      login: { request in
        Amplify.Auth.signIn(username: request.phoneNumber, password: request.password)
          .resultPublisher
          .map { som in
            print(som)
            return .done
          }
          .mapError(AuthClientError.init(from:))
          .eraseToEffect()
      },

      logout: {
        Amplify.Auth.signOut()
          .resultPublisher
          .map { .done }
          .mapError(AuthClientError.init(from:))
          .eraseToEffect()
      },

      signUp: { request in
        var userAttributes = [
          AuthUserAttribute(.phoneNumber, value: request.phoneNumber),
          AuthUserAttribute(.preferredUsername, value: request.username)
        ]

        if let fullname = request.name {
          userAttributes.append(AuthUserAttribute(.name, value: fullname))
        }
        if let birthdate = request.birthdate {
          userAttributes.append(AuthUserAttribute(.birthDate, value: dateFormatter.string(from: birthdate)))
        }

        let options = AuthSignUpRequest.Options(
          userAttributes: userAttributes
        )

        return Amplify.Auth.signUp(
          username: request.phoneNumber,
          password: request.password,
          options: options
        )
        .resultPublisher
        .flatMap { result -> AnyPublisher<AuthSignInResult, AuthError> in
          print(result)
          return Amplify.Auth.signIn(
            username: request.phoneNumber,
            password: request.password
          )
            .resultPublisher
            .eraseToAnyPublisher()
        }
        .map { _ in return .done }
        .mapError(AuthClientError.init(from:))
        .eraseToEffect()
      },

      // swiftlint:disable trailing_closure
      verifyUserExists: { phoneNumber in
        Amplify.Auth
          .signIn(
            username: sanitize(phoneNumber: phoneNumber),
            password: "dummyPassword"
          )
          .resultPublisher
          .map(\.isSignedIn)
          .catch({ error -> AnyPublisher<Bool, AuthClientError> in
            dump(error)
            var userExists: Bool

            switch error {
            case .notAuthorized:
              userExists = true
            case .service(_, _, let serviceError):
              guard let awsError = serviceError as? AWSCognitoAuthError else {
                return Fail(error: AuthClientError(from: error))
                  .eraseToAnyPublisher()
              }

              switch awsError {
              case .userNotFound:
                userExists = false
              case .usernameExists, .userNotConfirmed:
                userExists = true
              default:
                return Fail(error: AuthClientError(from: error))
                  .eraseToAnyPublisher()
              }
            default:
              return Fail(error: AuthClientError(from: error))
                .eraseToAnyPublisher()
            }

            return Just(userExists)
              .setFailureType(to: AuthClientError.self)
              .eraseToAnyPublisher()
          })
          .eraseToEffect()
      }
    )
    // swiftlint:enable trailing_closure
  }
}

extension AuthClientError {
  init(from error: AuthError) {
    self.init(
      description: error.errorDescription,
      recoverySuggestion: error.recoverySuggestion
    )
  }
}

let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "MM/dd/yyyy"
  return dateFormatter
}()
