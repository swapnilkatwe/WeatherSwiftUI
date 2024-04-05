//
//  NetworkManager.swift
//  Weather
//
//  Created by Swapnil Katwe on 04/04/24.
//

import Foundation

struct AppConfig {
    static let shared = AppConfig()
    
    let key = Constants.Strings.keyAPI
    let baseURL = Constants.Strings.url

    func getCurrentWeatherURL(latitude: Double, longitude: Double) -> URL? {
        guard let baseUrl = URL(string: AppConfig.shared.baseURL + "/onecall") else {
            debugPrint(NetworkError.invalidURL)
            return nil
        }
        
        let queryParam = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "\(key)"),
            URLQueryItem(name: "exclude", value: "minutely"),
            URLQueryItem(name: "units", value: "metric"),
        ]

        return baseUrl.appendingQueryParameters(queryParam)
    }
}

class NetworkManager: NetworkService {

    private let appConfig: AppConfig
    
    init(appConfig: AppConfig = AppConfig.shared) {
        self.appConfig = appConfig
    }

    // For @escaping Closure based
    func fetchWeather(for url: URL, queryParam: [URLQueryItem]? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = buildRequest(url: url, method: "GET", queryParam: queryParam)
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            self?.handleResponse(data: data,
                                 response: response,
                                 error: error,
                                 completionHandler: completion)
        }.resume()
    }
    
    // For async await based
    func fetchWeatherAsync(for url: URL, queryParam: [URLQueryItem]? = nil) async throws -> Data {
        let request = buildRequest(url: url, method: "GET", queryParam: queryParam)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let filteredData = try await handleResponseAsync(data: data, response: response)
            return filteredData
        } catch {
            throw NetworkError.apiError(error.localizedDescription)
        }
    }
}
