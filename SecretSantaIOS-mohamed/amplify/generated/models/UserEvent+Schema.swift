// swiftlint:disable all
import Amplify
import Foundation

extension UserEvent {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case eventID
    case participantID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userEvent = UserEvent.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserEvents"
    model.syncPluralName = "UserEvents"
    
    model.attributes(
      .primaryKey(fields: [userEvent.id])
    )
    
    model.fields(
      .field(userEvent.id, is: .required, ofType: .string),
      .field(userEvent.eventID, is: .required, ofType: .string),
      .field(userEvent.participantID, is: .required, ofType: .string),
      .field(userEvent.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userEvent.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserEvent: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}