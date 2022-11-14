// swiftlint:disable all
import Amplify
import Foundation

extension LoginPost {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case status
    case rating
    case content
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let loginPost = LoginPost.keys
    
    model.authRules = [
      rule(allow: .groups, groupClaim: "cognito:groups", groups: ["Admin"], provider: .userPools, operations: [.create, .update, .delete]),
      rule(allow: .public, provider: .apiKey, operations: [.read])
    ]
    
    model.pluralName = "LoginPosts"
    
    model.fields(
      .id(),
      .field(loginPost.title, is: .required, ofType: .string),
      .field(loginPost.status, is: .required, ofType: .enum(type: PostStatus.self)),
      .field(loginPost.rating, is: .optional, ofType: .int),
      .field(loginPost.content, is: .optional, ofType: .string),
      .field(loginPost.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(loginPost.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}