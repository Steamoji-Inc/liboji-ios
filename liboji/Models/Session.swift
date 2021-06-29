//
//  Session.swift
//  Academy
//
//  Created by William Casarin on 2020-05-22.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public typealias SessionID = String

public struct SessionArtifacts: Encodable {
    public var note: String?
    public var videoURL: String?
    public var thumbnailURL: String?
    public var bonusPoints: Int?

    public init(note: String?, videoURL: String?, thumbnailURL: String?, bonusPoints: Int?) {
        self.note = note
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.bonusPoints = bonusPoints
    }
}

public struct UpdateSessionArtifacts: Encodable {
    public var artifacts: SessionArtifacts
    public var sessionID: String
}

public class Session: Codable {
    public var id: SessionID
    public var dateTime: String
    public var workStation: Int?
    public var step: Int?
    public var note: String?
    public var minutes: Int?
    public var artefactVideoURL: String?
    public var artefactThumbnailURL: String?
    public var bonusPoints: Int
    public var apprentice: User?
    public var project: Project?
    public var mission: Mission?

    private var _startTime: Date?

    public func startTime() -> Date {
        guard let start = _startTime else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            _startTime = dateFormatter.date(from: self.dateTime)
            return _startTime ?? Date()
        }

        return start
    }

    public func getStep() -> Int {
      return step ?? 0
    }
}

public struct SessionsWrapper: Decodable {
    var sessions: [Session]
}

public struct SessionUpsertWrapper: Decodable {
    var session: Session?
}


