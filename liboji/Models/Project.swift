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
    public var instructions: String?
    public var introduction: String?
    public var objective: String?
    public var requiredMaterials: String?
    public var tools: String?
    public var safetyRestrictions: String?
    public init(name: String, id: String) {
        self.name = name
        self.id = id
        self.instructions = nil
        self.introduction = nil
        self.objective = nil
        self.requiredMaterials = nil
        self.tools = nil
        self.safetyRestrictions = nil
    }
}
