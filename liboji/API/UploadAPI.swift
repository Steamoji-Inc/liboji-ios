//
//  UploadAPI.swift
//  Academy
//
//  Created by William Casarin on 2020-06-09.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation
import Macaroons

public let GetPresignedUploadURLQuery = """
query GetUploadURL($filePrefix: String!) {
  getUploadURL(filePrefix: $filePrefix)
}
"""

public struct GetUploadURL: Encodable {
    public var filePrefix: String
}

public func getArtifactUploadURL(
    apiHost: URL,
    identoji: Macaroon,
    callback: @escaping (RequestRes<URL>) -> Void)
{
    return getPresignedUploadURL(
        apiHost: apiHost,
        identoji: identoji,
        filePrefix: "video-artifact-",
        callback: callback)
}

public func getPresignedUploadURL(
    apiHost: URL,
    identoji: Macaroon,
    filePrefix: String,
    callback: @escaping (RequestRes<URL>) -> Void)
{
    let input = GetUploadURL(filePrefix: filePrefix)

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "GetUploadURL",
        query: GetPresignedUploadURLQuery,
        variables: input)
    { (res: RequestRes<PresignedURL>) -> Void in
        callback(res.flatMap {
            guard let url = URL(string: $0.getUploadURL) else {
                return .failure(RequestError(errorType: .unknown("Invalid Upload URL")))
            }

            return .success(url)
        })
    }
}

public func uploadVideoArtifact(
    url: URL,
    file: URL,
    completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
{
    var req = URLRequest(url: url)
    req.httpMethod = "PUT"

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    let task = session.uploadTask(with: req, fromFile: file, completionHandler: completion)
    task.resume()

    return task
}

