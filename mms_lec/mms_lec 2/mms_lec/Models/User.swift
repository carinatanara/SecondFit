//
//  User.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 17/10/25.
//

import Foundation

struct User: Decodable {
  let username: String?
  let email: String?
  
  enum CodingKeys: String, CodingKey {
    case username
    case email
  }
}
struct UpdateProfileParams: Encodable {
  let username: String
  let email: String

  enum CodingKeys: String, CodingKey {
    case username
    case email
  }
}
