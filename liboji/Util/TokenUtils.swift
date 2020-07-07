//
//  TokenUtils.swift
//  liboji
//
//  Created by William Casarin on 2020-07-07.
//  Copyright © 2020 William Casarin. All rights reserved.
//

import Foundation
import Macaroons

func hasIdentojiExpired(_ identoji: Macaroon) -> Bool {
    var hadExpire = false
    for caveat in identoji.caveats {
        if caveat.id.starts(with: "expire") {
            hadExpire = true

            let parts = caveat.id.split(separator: Character(" "))

            // malformed, just return expired to get a new one
            if parts.count != 2 {
                return true
            }

            guard let n = Int(parts[1]) else {
                return true
            }

            if Int(NSDate().timeIntervalSince1970) >= n {
                return true
            }
        }
    }

    // no expire caveat?
    if !hadExpire {
        print("UNUSUAL: identoji doesn't have an expire caveat")
        return true
    }

    // no expire caveat has expired
    return false
}

