//
//  Session.swift
//  Academy
//
//  Created by William Casarin on 2020-06-09.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public let ApprenticeStatsFragment = """
    apprenticeStats(userId: $userId) {
        missionsComplete
        projectsComplete
        level
        levelName
        points
        redeemed
    }
"""

// quick hack to grab house team
public let FamilyFragment = """
  userFamily(userId: $userId) {
    houseTeam
  }
"""

public let ApprenticeMetadataQuery = """
query ApprenticeMetadata($userId: ID!) {
  \(ApprenticeStatsFragment)
  \(FamilyFragment)
}
"""

public struct Family: Codable {
    public var id: String?
    public var name: String?
    public var address1: String?
    public var city: String?
    public var country: String?
    public var state: String?
    public var phoneNumber: String?
    public var isUpgraded: Bool?
    public var houseTeam: String?
    public var members: [User]?
    
    static var empty: Family {
        return Family(id: nil, name: nil, address1: nil, city: nil, country: nil, state: nil, phoneNumber: nil, isUpgraded: nil, houseTeam: nil, members: nil)
    }
    
    public init(id: String?, name: String?, address1: String?, city: String?, country: String?, state: String?, phoneNumber: String?, isUpgraded: Bool?, houseTeam: String?, members: [User]?) {
        self.id = id
        self.name = name
        self.address1 = address1
        self.city = city
        self.country = country
        self.state = state
        self.phoneNumber = phoneNumber
        self.isUpgraded = isUpgraded
        self.houseTeam = houseTeam
        self.members = members
    }
    
    public init(other: Family) {
        self.id = other.id
        self.name = other.name
        self.address1 = other.address1
        self.city = other.city
        self.country = other.country
        self.state = other.state
        self.phoneNumber = other.phoneNumber
        self.isUpgraded = other.isUpgraded
        self.houseTeam = other.houseTeam
        self.members = other.members ?? []
    }
}

public struct ApprenticeMetadata: Decodable {
    public let apprenticeStats: ApprenticeStats
    public let userFamily: Family

    public init(stats: ApprenticeStats, family: Family) {
        self.apprenticeStats = stats
        self.userFamily = family
    }
}

public struct UserIdParam: Encodable {
    public let userId: String
}

public struct ApprenticeStats: Decodable {
    public let missionsComplete: Int
    public let projectsComplete: Int
    public let level: Int
    public let levelName: String
    public let points: Int
    public let redeemed: Int

    public init(
        missionsComplete: Int,
        projectsComplete: Int,
        level: Int,
        levelName: String,
        points: Int,
        redeemed: Int
    ) {
        self.missionsComplete = missionsComplete
        self.projectsComplete = projectsComplete
        self.level = level
        self.levelName = levelName
        self.points = points
        self.redeemed = redeemed
    }
}

public func fetchApprenticeMetadata(
    apiHost: URL,
    identoji: Macaroon,
    userId: String,
    completion: @escaping (RequestRes<ApprenticeMetadata>) -> Void
) {
    let input = UserIdParam(userId: userId)

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "ApprenticeMetadata",
        query: ApprenticeMetadataQuery,
        variables: input,
        cb: completion
    )
}

@available(iOS 15.0, *)
public func fetch_apprentice_metadata(
    apiHost: URL,
    identoji: Macaroon,
    userId: String) async throws -> ApprenticeMetadata
{
    let input = UserIdParam(userId: userId)
    return try await gqlQueryAsync(
        apiHost: apiHost,
        identoji: identoji,
        operation: "ApprenticeMetadata",
        query: ApprenticeMetadataQuery,
        variables: input)
}
