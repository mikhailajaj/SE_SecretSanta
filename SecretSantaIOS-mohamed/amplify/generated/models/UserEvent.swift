// swiftlint:disable all
import Amplify
import Foundation

public struct UserEvent: Model {
  public let id: String
  public var eventID: String
  public var participantID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      eventID: String,
      participantID: String) {
    self.init(id: id,
      eventID: eventID,
      participantID: participantID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      eventID: String,
      participantID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.eventID = eventID
      self.participantID = participantID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}