
//
//  TokenUtils.swift
//  liboji
//
//  Created by William Casarin on 2020-07-07.
//  Copyright © 2020 William Casarin. All rights reserved.
//

import Foundation
import Macaroons

public func steamoji_asset_url(_ fname: String) -> String {
    var url = "https://assets.steamoji.com"

    if fname.starts(with: url) {
        return fname
    }

    if fname == "" || fname == url {
        return ""
    }

    if !fname.starts(with: "/") {
        url += "/"
    }

    return url + fname
}

