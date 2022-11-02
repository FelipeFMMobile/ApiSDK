//
//  WebDomain.swift
//  UpcomingMoviesApi
//
//  Created by FMMobile on 19/05/2019.
//  Copyright © 2019 FMMobile. All rights reserved.
//

import Foundation

public struct ServerConfig {
    public static let dateFormat = "yyyy-MM-dd"
    public static let imagesBaseUrl = "https://image.tmdb.org/t/p/w185/"
    public static let key = "1f54bd990f1cdfb230adb312546d765d"
}

// Domain control
// Check target bundle to switch between domains
// Homolg and dev domains is not avalaible

public protocol WebDomainProtocol {
    func domainForBundle() -> String
    func config() -> ServerConfig
}
