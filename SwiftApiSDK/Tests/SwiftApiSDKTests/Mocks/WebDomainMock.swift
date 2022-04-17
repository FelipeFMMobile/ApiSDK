//
//  WebDomainMock.swift
//  
//
//  Created by Felipe Menezes on 17/04/22.
//

import Foundation
@testable import SwiftApiSDK
public struct WebDomainMock: WebDomainProtocol {
    enum Domain: String {
    case producao = "https://api.themoviedb.org/3/"
    case homolog = "https://homolog.themoviedb.org/3/"
    case dev = "localhost://api.themoviedb.org/3/"
    }

    public func domainForBundle() -> String {
        if let bundleID = Bundle.main.bundleIdentifier {
            if bundleID.range(of: "homolog") != nil {
                return Domain.homolog.rawValue
            }
            if bundleID.range(of: "dev") != nil {
                return Domain.dev.rawValue
            }
        }
        return Domain.producao.rawValue
    }

    public func config() -> ServerConfig {
        return ServerConfig()
    }
}
