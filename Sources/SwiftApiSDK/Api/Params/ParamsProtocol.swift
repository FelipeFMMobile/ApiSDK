//
//  ParamsProtocol.swift
//  UpcomingMoviesApi
//
//  Created by FMMobile on 19/05/2019.
//  Copyright © 2019 FMMobile. All rights reserved.
//

import Foundation

public protocol ParamsProtocol {
    var params: [String: Any] { get set }
    init(params: [String: Any])
    func buildParams(request: URLRequest) -> URLRequest
}
