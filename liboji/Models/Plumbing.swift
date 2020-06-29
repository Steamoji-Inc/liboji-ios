//
//  Plumbing.swift
//  Academy
//
//  Created by William Casarin on 2020-06-09.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation

public struct GQLResponse<T: Decodable>: Decodable {
    public var data: T
}

public struct Empty: Codable {
}

public struct IdWrapper: Decodable {
    public var id: String
}
