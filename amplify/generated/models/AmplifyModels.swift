// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "21d1ae928e6b817175b4f5e0cc9ec89c"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: LoginPost.self)
    ModelRegistry.register(modelType: PLoginPost.self)
  }
}