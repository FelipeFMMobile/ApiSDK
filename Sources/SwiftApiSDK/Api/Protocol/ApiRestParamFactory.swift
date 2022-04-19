//
//  ApiRestParamFactory.swift
//  UpcomingMoviesApi
//
//  Created by Felipe Menezes on 21/01/22.
//  Copyright © 2022 FMMobile. All rights reserved.
//

public protocol ApiRestParamFactoryProtocol {
    func generate<T: WebDomainProtocol>(domain: T.Type,
                  endPoint: String,
                  params: ParamsProtocol) -> ApiRestParamProtocol
    func generate<T: WebDomainProtocol>(domain: T.Type,
                  method: HttpMethod,
                  endPoint: String,
                  params: ParamsProtocol) -> ApiRestParamProtocol
}

extension ApiRestParamFactoryProtocol {
    public func generate<T: WebDomainProtocol>(domain: T.Type,
                                               endPoint: String,
                                               params: ParamsProtocol) -> ApiRestParamProtocol {
        ApiRestParam<T>(endPoint: endPoint, params: params)
    }

    public func generate<T: WebDomainProtocol>(domain: T.Type,
                                               method: HttpMethod,
                                               endPoint: String,
                                               params: ParamsProtocol) -> ApiRestParamProtocol {
        let param = ApiRestParam<T>(endPoint: endPoint, params: params)
        param.method = method
        return param
    }
}

public enum ApiParamFactory: ApiRestParamFactoryProtocol {
    case basic
}
