//
//  Project.swift
//  Academy
//
//  Created by Steve Sun on 2020-05-24.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation

public typealias ProjectID = String

public struct Project: Codable {
    public var id: ProjectID
    public var name: String
}
