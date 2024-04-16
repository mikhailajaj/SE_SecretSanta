// swiftlint:disable all
import Amplify
import Foundation

public struct Event: Model {
  public let id: String
  public var name: String?
  public var participants_num: Int?
  public var participants_joined_num: Int?
  public var code: String?
  public var date: Temporal.DateTime?
  public var location: String?
  public var description: String?
  public var isfull: Bool?
  public var hostID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String? = nil,
      participants_num: Int? = nil,
      participants_joined_num: Int? = nil,
      code: String? = nil,
      date: Temporal.DateTime? = nil,
      location: String? = nil,
      description: String? = nil,
      isfull: Bool? = nil,
      hostID: String) {
    self.init(id: id,
      name: name,
      participants_num: participants_num,
      participants_joined_num: participants_joined_num,
      code: code,
      date: date,
      location: location,
      description: description,
      isfull: isfull,
      hostID: hostID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String? = nil,
      participants_num: Int? = nil,
      participants_joined_num: Int? = nil,
      code: String? = nil,
      date: Temporal.DateTime? = nil,
      location: String? = nil,
      description: String? = nil,
      isfull: Bool? = nil,
      hostID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.participants_num = participants_num
      self.participants_joined_num = participants_joined_num
      self.code = code
      self.date = date
      self.location = location
      self.description = description
      self.isfull = isfull
      self.hostID = hostID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}