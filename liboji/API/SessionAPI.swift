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
query Sessions() {
    sessions {
        workStation
        step
        id
        note
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
            familyId
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

public func loadActiveSessions(
    apiHost: URL,
    identoji: Macaroon,
    completion: @escaping (RequestRes<[Session]>) -> Void)
{
    let input: [String: Int] = [String: Int]()

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "Sessions",
        query: SessionsQuery,
        variables: input)
    { (res: RequestRes<SessionsWrapper>) -> Void in completion(res.map { $0.sessions }) }
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
