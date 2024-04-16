// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b0fca5e46350e42af73a36d8616f1aa7"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Event.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: UserEvent.self)
  }
}