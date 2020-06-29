//
//  User.swift
//  Academy
//
//  Created by Steve Sun on 2020-05-22.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation

public typealias UserID = String

public struct User: Codable {
    public var id: UserID
    public var firstName: String?
    public var lastName: String?
    public var avatarFilename: String?
    public var gender: String?
}
