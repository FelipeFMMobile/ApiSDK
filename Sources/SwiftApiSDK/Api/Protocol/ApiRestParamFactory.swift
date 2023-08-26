//
//  ApiRestParamFactory.swift
//  UpcomingMoviesApi
//
//  Created by Felipe Menezes on 21/01/22.
//  Copyright © 2022 FMMobile. All rights reserved.
//

public protocol ApiRestParamFactoryProtocol {
    func generate<T: WebDomainProtocol>(domain: T.Type,
                  endPoint: EndPoint,
                  params: ParamsProtocol) -> ApiRestParamProtocol
}

extension ApiRestParamFactoryProtocol {
    public func generate<T: WebDomainProtocol>(domain: T.Type,
                                               endPoint: EndPoint,
                                               params: ParamsProtocol) -> ApiRestParamProtocol {
        ApiRestParam<T>(endPoint: endPoint, params: params)
    }
}

public enum ApiParamFactory: ApiRestParamFactoryProtocol {
    case basic
}
