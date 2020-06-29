//
//  Auth.swift
//  Academy
//
//  Created by William Casarin on 2020-05-22.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public struct AuthResult: Decodable {
    public var email: String
    public var firstName: String
    public var lastName: String
}

