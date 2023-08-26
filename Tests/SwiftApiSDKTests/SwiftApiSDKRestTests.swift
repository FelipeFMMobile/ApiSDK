//
//  UpcomingMoviesApiTests.swift
//  UpcomingMoviesApiTests
//
//  Created by FMMobile on 19/05/2019.
//  Copyright © 2019 FMMobile. All rights reserved.
//

import XCTest
@testable import SwiftApiSDK
import OHHTTPStubs
import OHHTTPStubsSwift

public enum UpcomingEndpoints {
    case upComing
    case genres
    case movie
}

extension UpcomingEndpoints: EndPoint {
    public func path() -> Path {
        switch self {
        case .upComing:
            return "movie/upcoming"
        case .genres:
            return "genre/movie/list"
        case .movie:
            return "movie/"
        }
    }
    public func header() -> Header {
        switch self {
        default:
            return [:]
        }
    }

    public func method() -> HttpMethod {
        switch self {
        default:
            return .GET
        }
    }

    public func contentType() -> ContentType {
        switch self {
        default:
            return .json
        }
    }
}

class SwiftApiSDKRestTests: XCTestCase {

    override func setUp() {
        HTTPStubs.setEnabled(true)
        HTTPStubs.onStubActivation { (request: URLRequest, stub: HTTPStubsDescriptor, _: HTTPStubsResponse) in
            print("[OHHTTPStubs] Request to \(request.url!) has been stubbed with \(String(describing: stub.name))")
        }
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func testNovaApiRequest_MockGenreList_True() {
        stub(condition: isPath("api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d")) { _ in
            let stubPath = Bundle.module.url(forResource: "Genre", withExtension: "json")!.path
            return fixture(filePath: stubPath, status: 200, headers: ["Content-Type": "application/json"])
        }

        let api: ApiRestProtocol = ApiRest()
        let promise = expectation(description: "Api Request")
        let checkUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d"
        let params = GetParams(params: ["api_key": "1f54bd990f1cdfb230adb312546d765d"])
        api.run(param: ApiParamFactory.basic.generate(domain: WebDomainMock.self,
                                                      endPoint: UpcomingEndpoints.genres,
                                                      params: params), GenreList.self) { result, request in
            switch result {
            case .success(let result):
                XCTAssertTrue(!result.genres.isEmpty)
                XCTAssert(request?.url?.absoluteString == checkUrl)
            case .failure:
                XCTFail("Failure not allowed")
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
