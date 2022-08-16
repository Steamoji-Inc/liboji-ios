//
//  SteamojiRequest.swift
//  Academy
//
//  Created by William Casarin on 2020-06-05.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public func attenuateIdentoji(identoji: Macaroon) -> Macaroon {
    var attenuated = Macaroon(other: identoji)
    /// watch out for device clock skew here, perhaps we should bump this to 5 minutes
    let expires = Int(NSDate().timeIntervalSince1970 + 60 * 5)
    attenuated.addFirstPartyCaveat("expire \(expires)")
    return attenuated
}

/// This is just gqlRequest but we also pass in our identoji Authorization header
public func gqlQuery<IN: Encodable, OUT: Decodable>(
    apiHost: URL,
    identoji: Macaroon,
    operation: String,
    query: String,
    variables: IN,
    cb: @escaping (RequestRes<OUT>) -> Void)
{
    let url = apiHost.appendingPathComponent("/query")

    var httpReq = URLRequest(url: url)
    let identojiStr = attenuateIdentoji(identoji: identoji).serialize()
    let authHeader = "identoji \(identojiStr)"
    httpReq.setValue(authHeader, forHTTPHeaderField: "authorization")

    let req = GQLRequest(operationName: operation,
                         variables: variables,
                         query: query)

    gqlRequest(query: req, req: &httpReq, cb: cb)
}


/// This is just gqlRequest but we also pass in our identoji Authorization header
@available(iOS 15.0, *)
public func gqlQueryAsync<IN: Encodable, OUT: Decodable>(
    apiHost: URL,
    identoji: Macaroon,
    operation: String,
    query: String,
    variables: IN) async throws -> OUT
{
    let url = apiHost.appendingPathComponent("/query")

    var httpReq = URLRequest(url: url)
    let identojiStr = attenuateIdentoji(identoji: identoji).serialize()
    let authHeader = "identoji \(identojiStr)"
    httpReq.setValue(authHeader, forHTTPHeaderField: "authorization")

    let req = GQLRequest(operationName: operation,
                         variables: variables,
                         query: query)

    let res: OUT = try await gqlRequestAsync(query: req, req: &httpReq)
    return res
}
