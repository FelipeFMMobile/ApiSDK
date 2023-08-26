//
//  ApiRestParam.swift
//  UpcomingMoviesApi
//
//  Created by Felipe Menezes on 19/01/22.
//  Copyright © 2022 FMMobile. All rights reserved.
//

import UIKit

public protocol ApiRestParamProtocol: AnyObject {
    var domain: WebDomainProtocol { get }
    var endPoint: EndPoint { get }
    var params: ParamsProtocol { get }
    var header: ApiHeader { get }
    func generateDefaultHeader()
    func debugLog()
}

extension ApiRestParamProtocol {
    public func generateDefaultHeader() {
        header.addHeaderValue(key: "User-Agent", value: "UpcomingMovies/1.0")
        header.addHeaderValue(key: "Content-Type", value: endPoint.contentType().contentType())
        header.addHeaderValue(key: "Accept-Encoding", value: endPoint.contentType().contentType())
        header.addHeaderValue(key: "x-manufactor", value: "Apple")
        header.addHeaderValue(key: "x-model", value: UIDevice.current.model)
        header.addHeaderValue(key: "x-system", value: UIDevice.current.systemVersion)
        endPoint.header().forEach { header.addHeaderValue(key: $0.key, value: $0.value )}
    }

    public func debugLog() {
        debugPrint("📡")
        debugPrint("# REQUEST --------------------- ")
        debugPrint("## DOMAIN: \(domain.domainForBundle() + endPoint.path()) ")
        header.header.forEach {
            debugPrint("## HEADER [ \($0.key) : \($0.value) ]")
        }
        debugPrint("## ENDPOINT: \(endPoint.method().verb()) ")
        debugPrint("## ENDPOINT: \(endPoint.contentType().contentType().lowercased()) ")
        params.params.forEach {
            debugPrint("## PARAMS [ \($0.key) : \($0.value) ]")
        }
        
    }
}

public class ApiRestParam<T: WebDomainProtocol>: ApiRestParamProtocol {
    public var domain: WebDomainProtocol
    public var endPoint: EndPoint
    public var params: ParamsProtocol
    public var header: ApiHeader = ApiHeaderSimple()
    init(endPoint: EndPoint, params: ParamsProtocol) {
        self.params = params
        self.domain = T()
        self.endPoint =  endPoint
    }
}
