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
    var method: HttpMethod { get }
    var contentType: ContentType { get }
    var endPoint: String { get }
    var params: ParamsProtocol { get }
    var header: ApiHeader { get }
    func generateDefaultHeader()
}

extension ApiRestParamProtocol {
    public func generateDefaultHeader() {
        header.addHeaderValue(key: "User-Agent", value: "UpcomingMovies/1.0")
        header.addHeaderValue(key: "Content-Type", value: contentType.contentType())
        header.addHeaderValue(key: "Accept-Encoding", value: contentType.contentType())
        header.addHeaderValue(key: "x-manufactor", value: "Apple")
        header.addHeaderValue(key: "x-model", value: UIDevice.current.model)
        header.addHeaderValue(key: "x-system", value: UIDevice.current.systemVersion)
    }
}

public class ApiRestParam<T: WebDomainProtocol>: ApiRestParamProtocol {
    public var domain: WebDomainProtocol
    public var method: HttpMethod = .GET
    public var contentType: ContentType = .json
    public var endPoint: String
    public var params: ParamsProtocol
    public var header: ApiHeader = ApiHeaderSimple()
    init(endPoint: String, params: ParamsProtocol) {
        self.params = params
        self.domain = T()
        self.endPoint =  domain.domainForBundle() + endPoint
        
    }
}
