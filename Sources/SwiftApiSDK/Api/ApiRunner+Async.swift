//
//  File.swift
//  
//
//  Created by Felipe Menezes on 10/05/24.
//
import Foundation

@available(iOS 15.0, *)
extension ApiRunner: ApiRestAsyncProtocol {
    public func run<T>(param: any ApiRestParamProtocol, _ resultModel: T.Type) async throws -> (T,  URLRequest?) where T : Decodable {
        let request = try self.createRequest(param: param)
        let (data, response) = try await session.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        if statusCode == 200 {
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return (result, request)
            } catch let jsonError {
                debugPrint(jsonError)
                throw ApiError.contentSerializeError(self.defaultError(errorType: .responseCodableFail,
                                                                       statusCode))
            }
        } else {
            throw ApiError.statusCodeError(statusCode)
        }
    }
}
