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
    public var familyRole: String?
    public var houseTeam: String?
    public var note: String?

    public init(id: String) {
        self.id = id
    }

    public init(id: String, firstName: String?, lastName: String?, avatarFilename: String?, familyRole: String?, houseTeam: String?, note: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarFilename = id
        self.familyRole = familyRole
        self.houseTeam = houseTeam
        self.note = note
    }
}

