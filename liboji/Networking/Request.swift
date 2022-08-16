//
//  Request.swift
//  Academy
//
//  Created by William Casarin on 2020-05-22.
//  Copyright © 2020 Steamoji, Inc. All rights reserved.
//

import Foundation

public typealias RequestRes<T> = Result<T, RequestError>

public enum RequestErrorType: Error {
    case domain
    case decoding(DecodingError)
    case encoding(EncodingError)
    case status(Int)
    case unknown(String)
}

public struct RequestError: Error, CustomStringConvertible {
    public var response: HTTPURLResponse?
    public var respData: Data = Data()
    public var errorType: RequestErrorType

    public var description: String {
        let strData = String(decoding: respData, as: UTF8.self)

        guard let resp = response else {
            return "respData: \(strData)\nerrorType: \(errorType)\n"
        }

        return "response: \(resp)\nrespData: \(strData)\nerrorType: \(errorType)\n"
    }
}

public struct GQLRequest<T: Encodable>: Encodable {
    public var operationName: String
    public var variables: T
    public var query: String
}

public func gqlRequest<IN: Encodable, OUT: Decodable>(
    query: GQLRequest<IN>,
    req: inout URLRequest,
    cb: @escaping (RequestRes<OUT>) -> Void)
{
    do {
        req.httpBody = try JSONEncoder().encode(query)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    catch let err as EncodingError {
        let reqErr = RequestError(respData: Data(), errorType: .encoding(err))
        cb(.failure(reqErr))
    }
    catch let unk {
        let reqErr = RequestError(respData: Data(), errorType: .unknown("\(unk)"))
        cb(.failure(reqErr))
    }

    jsonHttpRequest(req: req) { (res: RequestRes<GQLResponse<OUT>>) -> Void in
        cb(res.map { $0.data })
    }
}

@available(iOS 15.0, *)
public func gqlRequestAsync<IN: Encodable, OUT: Decodable>(
    query: GQLRequest<IN>,
    req: inout URLRequest) async throws -> OUT
{
    do {
        req.httpBody = try JSONEncoder().encode(query)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    catch let err as EncodingError {
        throw RequestError(respData: Data(), errorType: .encoding(err))
    }
    catch let unk {
        throw RequestError(respData: Data(), errorType: .unknown("\(unk)"))
    }

    let res: GQLResponse<OUT> = try await jsonHttpRequestAsync(req: req)
    return res.data
}


func decodeJSON<T: Decodable>(dat: Data) -> Result<T, Error> {
    do {
        let dat = try JSONDecoder().decode(T.self, from: dat)
        return .success(dat)
    }
    catch let unk {
        return .failure(unk)
    }
}

public func jsonHttpRequest<T: Decodable>(req: URLRequest, cb: @escaping (RequestRes<T>) -> Void)
{
    httpRequest(req: req, decoder: decodeJSON, cb: cb )
}

@available(iOS 15.0, *)
public func jsonHttpRequestAsync<T: Decodable>(req: URLRequest) async throws -> T {
    return try await httpRequestAsync(req: req, decoder: decodeJSON)
}

public func httpRequest<T>(req: URLRequest,
                           decoder: @escaping ((Data) -> Result<T, Error>),
                           cb: @escaping (RequestRes<T>) -> Void)
{
    URLSession.shared.dataTask(with: req) { datas, resp, err in
        guard let resp = resp as? HTTPURLResponse else {
            let reqErr = RequestError(response: nil, respData: datas ?? Data(), errorType: .domain)
            cb(.failure(reqErr))
            return
        }

        guard let dat = datas, err == nil else {
            if let err = err as NSError?, err.domain == NSURLErrorDomain {
                let reqErr = RequestError(response: resp, errorType: .domain)
                cb(.failure(reqErr))
            }
            return
        }

        if resp.statusCode < 200 || resp.statusCode >= 300 {
            let reqErr = RequestError(response: resp, respData: dat, errorType: .status(resp.statusCode))
            cb(.failure(reqErr))
            return
        }

        switch decoder(dat) {
        case .success(let decoded):
            cb(.success(decoded))
        case .failure(let err as DecodingError):
            let reqErr = RequestError(response: resp, respData: dat, errorType: .decoding(err))
            cb(.failure(reqErr))
        case .failure(let unk):
            let reqErr = RequestError(response: resp, respData: dat, errorType: .unknown("\(unk)"))
            cb(.failure(reqErr))
        }

    }.resume()
}

@available(iOS 15.0, *)
public func httpRequestAsync<T>(
    req: URLRequest,
    decoder: @escaping ((Data) -> Result<T, Error>) ) async throws -> T
{
    let (dat, resp) = try await URLSession.shared.data(for: req)

    guard let resp = resp as? HTTPURLResponse else {
        throw RequestError(response: nil, respData: dat, errorType: .domain)
    }

    if resp.statusCode < 200 || resp.statusCode >= 300 {
        throw RequestError(response: resp, respData: dat, errorType: .status(resp.statusCode))
    }

    switch decoder(dat) {
    case .success(let decoded):
        return decoded
    case .failure(let err as DecodingError):
        throw RequestError(response: resp, respData: dat, errorType: .decoding(err))
    case .failure(let unk):
        throw RequestError(response: resp, respData: dat, errorType: .unknown("\(unk)"))
    }
}
