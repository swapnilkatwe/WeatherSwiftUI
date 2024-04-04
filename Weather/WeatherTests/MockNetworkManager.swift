//
//  MockNetworkManager.swift
//  WeatherTests
//
//  Created by Swapnil Katwe on 04/04/24.
//

import Foundation
@testable import Weather
final class MockNetworkManager: NetworkService {

    func fetchWeather(for url: URL, queryParam: [URLQueryItem]?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let path = Bundle.main.url(forResource: "MockWeatherResponse", withExtension: "json") else {
            fatalError("Json file error")
        }
        do {
            let data = try Data(contentsOf: path)
            return completion(.success(data))
        } catch {
            return completion(.failure(.noData))
        }
    }
    
}
