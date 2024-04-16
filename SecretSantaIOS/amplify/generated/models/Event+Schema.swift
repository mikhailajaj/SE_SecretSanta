// swiftlint:disable all
import Amplify
import Foundation

extension Event {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case participants_num
    case participants_joined_num
    case code
    case date
    case location
    case description
    case isfull
    case hostID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let event = Event.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Events"
    model.syncPluralName = "Events"
    
    model.attributes(
      .index(fields: ["hostID"], name: "byUser"),
      .primaryKey(fields: [event.id])
    )
    
    model.fields(
      .field(event.id, is: .required, ofType: .string),
      .field(event.name, is: .optional, ofType: .string),
      .field(event.participants_num, is: .optional, ofType: .int),
      .field(event.participants_joined_num, is: .optional, ofType: .int),
      .field(event.code, is: .optional, ofType: .string),
      .field(event.date, is: .optional, ofType: .dateTime),
      .field(event.location, is: .optional, ofType: .string),
      .field(event.description, is: .optional, ofType: .string),
      .field(event.isfull, is: .optional, ofType: .bool),
      .field(event.hostID, is: .required, ofType: .string),
      .field(event.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(event.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Event: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}