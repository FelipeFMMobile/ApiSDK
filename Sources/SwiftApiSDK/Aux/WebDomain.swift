//
//  WebDomain.swift
//  UpcomingMoviesApi
//
//  Created by FMMobile on 19/05/2019.
//  Copyright © 2019 FMMobile. All rights reserved.
//

import Foundation
// Domain control
// Check target bundle to switch between domains
// Homolg and dev domains is not avalaible

public protocol WebDomainProtocol {
    init()
    func domainForBundle() -> String
}
