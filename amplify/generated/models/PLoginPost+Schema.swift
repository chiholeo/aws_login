// swiftlint:disable all
import Amplify
import Foundation

extension PLoginPost {
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
    let pLoginPost = PLoginPost.keys
    
    model.authRules = [
      rule(allow: .groups, groupClaim: "cognito:groups", groups: ["Admin"], provider: .userPools, operations: [.create, .update, .delete]),
      rule(allow: .public, provider: .apiKey, operations: [.read])
    ]
    
    model.pluralName = "PLoginPosts"
    
    model.fields(
      .id(),
      .field(pLoginPost.title, is: .required, ofType: .string),
      .field(pLoginPost.status, is: .required, ofType: .enum(type: PostStatus.self)),
      .field(pLoginPost.rating, is: .optional, ofType: .int),
      .field(pLoginPost.content, is: .optional, ofType: .string),
      .field(pLoginPost.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(pLoginPost.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}