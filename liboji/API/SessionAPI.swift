//
//  Session.swift
//  Academy
//
//  Created by William Casarin on 2020-06-09.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public let SessionsQuery = """
query Sessions($locationId: ID) {
    organization {
      workStationNum
    }

    sessions(locationId: $locationId) {
        workStation
        step
        id
        note
        minutes
        dateTime
        artefactVideoURL
        artefactThumbnailURL
        bonusPoints
        project {
            id
            name
        }
        apprentice {
            id
            firstName
            lastName
            familyRole
            familyId
            avatarFilename
            note
        }
        mission {
            id
            title
        }
    }
}
"""

public let UpdateSessionArtifactsQuery = """
mutation UpdateSessionArtifacts($artifacts: SessionArtifactInput!, $sessionID: ID!) {
    updateSessionArtifacts(artifacts: $artifacts, sessionID: $sessionID)
}
"""

public struct AcademyStations: Decodable {
    public var workStationNum: Int?
}

public struct AcademySessions: Decodable {
    public var organization: AcademyStations
    public var sessions: [Session]
}

private struct LoadSessionsParams: Encodable {
    public var locationId: String?
}

public func loadActiveSessions(
    apiHost: URL,
    identoji: Macaroon,
    locationId: String?,
    completion: @escaping (RequestRes<AcademySessions>) -> Void)
{
    let input = LoadSessionsParams(locationId: locationId)

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "Sessions",
        query: SessionsQuery,
        variables: input,
        cb: completion
    )
}

public func updateSessionArtifacts(
    apiHost: URL,
    identoji: Macaroon,
    artifacts: SessionArtifacts,
    sessionID: String,
    completion: @escaping (RequestRes<Empty>) -> Void)
{
    let input = UpdateSessionArtifacts(artifacts: artifacts, sessionID: sessionID)

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "UpdateSessionArtifacts",
        query: UpdateSessionArtifactsQuery,
        variables: input,
        cb: completion)
}
