//
//  ApiExecute.swift
//  UpcomingMoviesApi
//
//  Created by FMMobile on 19/05/2019.
//  Copyright © 2019 FMMobile. All rights reserved.
//

import Foundation

open class ApiRunner: NSObject, ApiRestProtocol {
    lazy internal var session: URLSession = URLSession(configuration: self.configuration,
                                                      delegate: self,
                                                      delegateQueue: nil)
    lazy var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 3 * 60
        return config
    }()

    public func run<T>(param: ApiRestParamProtocol, _ resultModel: T.Type,
                       completion: @escaping ApiCompletionRequest<T>) where T: Decodable {
        let request: URLRequest
        do {
            request = try createRequest(param: param)
            // Request
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    completion(.failure(ApiError.networkingError(NSError(domain: error?.localizedDescription ?? "",
                                                                         code: 0, userInfo: nil))), nil)
                    return
                }

                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                var errorCode: ApiError = .statusCodeError(statusCode)
                if statusCode == 200 {
                    if let odata = data {
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(T.self, from: odata)
                            completion(.success(result), request)
                            return
                        } catch let jsonError {
                            errorCode = .contentSerializeError(self.defaultError(errorType: .responseCodableFail,
                                                                                 statusCode))
                            debugPrint(jsonError)
                        }
                    } else {
                        errorCode = .contentSerializeError(self.defaultError(errorType: .noDataResponse,
                                                                             statusCode))
                    }
                }
                completion(.failure(errorCode), request)
            })
            task.resume()
        } catch let error as ApiError {
            completion(.failure(error), nil)
        } catch {}
    }

    internal func createRequest(param: ApiRestParamProtocol) throws -> URLRequest {
        let urlString = param.domain.domainForBundle() + param.endPoint.path()
        guard let url = URL(string: urlString) else {
            throw ApiError.domainFail
        }
        var request = URLRequest(url: url)
        request.httpMethod = param.endPoint.method().verb()
        // HTTP Headers
        param.generateDefaultHeader()
        // headers
        for value in param.header.header {
            request.setValue(value.value, forHTTPHeaderField: value.key)
        }
        request = param.params.buildParams(request: request)

        param.debugLog()
        return request
    }

    internal func defaultError(errorType: ApiErrorCodes, _ errorCode: Int = 0) -> NSError {
        switch errorType {
        case .domainFail:
            return NSError(domain: "dominio ausente", code: errorType.rawValue, userInfo: nil)
        case .responseCodableFail:
            return NSError(domain: "response codable fail", code: errorType.rawValue, userInfo: nil)
        case .noDataResponse:
            return NSError(domain: "no data response fail", code: errorType.rawValue, userInfo: nil)
        case .statusCodeError:
            return NSError(domain: "erro no servidor \(errorCode)", code: errorCode, userInfo: nil)
        }
    }
}

extension ApiRunner: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                           willCacheResponse proposedResponse: CachedURLResponse,
                           completionHandler: @escaping (CachedURLResponse?) -> Void) {
        if proposedResponse.response.url?.scheme == "https" {
            let updatedResponse = CachedURLResponse(response: proposedResponse.response,
                                                    data: proposedResponse.data,
                                                    userInfo: proposedResponse.userInfo,
                                                    storagePolicy: .allowedInMemoryOnly)
            completionHandler(updatedResponse)
        } else {
            completionHandler(proposedResponse)
        }
    }
}
