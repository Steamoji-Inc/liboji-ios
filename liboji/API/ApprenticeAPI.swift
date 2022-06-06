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

public struct Family: Decodable {
    public let houseTeam: String?
}

public struct ApprenticeMetadata: Decodable {
    public let apprenticeStats: ApprenticeStats
    public let userFamily: Family
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
