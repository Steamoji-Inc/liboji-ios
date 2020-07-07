//
//  TokenUtils.swift
//  liboji
//
//  Created by William Casarin on 2020-07-07.
//  Copyright © 2020 William Casarin. All rights reserved.
//

import Foundation
import Macaroons

public func hasIdentojiExpired(_ identoji: Macaroon) -> Bool {
    let m_str_n = findCaveat(macaroon: identoji, startsWith: "expire")

    guard let str_n = m_str_n else {
        return true
    }

    guard let n = Int(str_n) else {
        return true
    }

    if Int(NSDate().timeIntervalSince1970) >= n {
        return true
    }

    // no expire caveat has expired
    return false
}

public func getIdentojiUserId(_ identoji: Macaroon) -> String? {
    return findCaveat(macaroon: identoji, startsWith: "user")
}

public func findCaveat(macaroon: Macaroon, startsWith: String) -> String? {
    for caveat in macaroon.caveats {
        if caveat.id.starts(with: startsWith) {
            let parts = caveat.id.split(separator: Character(" "))

            // malformed?
            if parts.count != 2 {
                return nil
            }

            return String(parts[1])
        }
    }

    return nil
}

