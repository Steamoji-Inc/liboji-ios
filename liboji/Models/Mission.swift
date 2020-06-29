//
//  Mission.swift
//  Academy
//
//  Created by Steve Sun on 2020-05-24.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation

public typealias MissionID = String

public struct Mission: Codable {
    public var id: MissionID
    public var title: String
}
