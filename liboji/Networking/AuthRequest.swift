//
//  Auth.swift
//  Academy
//
//  Created by William Casarin on 2020-05-27.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//


import Foundation
import Macaroons

public enum MacaroonError: Error {
    case decode
}

public func macaroonDecoder(data: Data) -> Result<Macaroon, Error>
{
    guard let strData = String(data: data, encoding: .utf8) else {
        return .failure(MacaroonError.decode)
    }

    guard let macaroon = Macaroon.deserialize(strData) else {
        return .failure(MacaroonError.decode)
    }

    return .success(macaroon)
}

private func makeAuthUrl(apiHost: URL,
                         queryItems: [URLQueryItem]) -> URL
{
    var components = URLComponents(url: apiHost, resolvingAgainstBaseURL: false)!
    components.path = "/auth1"
    components.queryItems = queryItems

    components.percentEncodedQuery =
        components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

    return components.url!
}

private func makeAuthReq(apiHost: URL, queryItems: [URLQueryItem]) -> URLRequest {
    let url = makeAuthUrl(apiHost: apiHost, queryItems: queryItems)
    var req = URLRequest(url: url)
    req.httpMethod = "GET"
    return req
}

public func requestIdentityToken(
    apiHost: URL,
    email: String,
    callback: @escaping (RequestRes<Macaroon>) -> Void)
{
    let emailQueryItem = URLQueryItem(name: "email", value: email)
    let req = makeAuthReq(apiHost: apiHost, queryItems: [emailQueryItem])

    httpRequest(req: req, decoder: macaroonDecoder, cb: callback)
}

public func submitIdentityToken(
    apiHost: URL,
    token: Macaroon,
    callback: @escaping (RequestRes<Macaroon>) -> Void)
{
    let tokenStr = token.serialize()
    let queryItem = URLQueryItem(name: "token", value: tokenStr)
    let req = makeAuthReq(apiHost: apiHost, queryItems: [queryItem])

    httpRequest(req: req, decoder: macaroonDecoder, cb: callback)
}
