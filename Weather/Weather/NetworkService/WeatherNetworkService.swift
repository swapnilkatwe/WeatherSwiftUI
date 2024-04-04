//
//  WeatherNetworkService.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import Foundation

enum NetworkError: Error {
    case apiError(String)
    case invalidResponse
    case httpError(Int)
    case noData
    case invalidURL
}

protocol NetworkService {
    func fetchWeather(for url: URL, queryParam: [URLQueryItem]? , completion: @escaping (Result<Data, NetworkError>) -> Void)
}

extension NetworkService {

    func buildRequest(url: URL,
                      method: String = "GET",
                      queryParam: [URLQueryItem]? = nil ) -> URLRequest {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryParam
        var request = URLRequest(url: components?.url ?? url)
        request.httpMethod = method
        return request
    }
    
    func handleResponse(data: Data?,
                       response: URLResponse?,
                       error: Error?,
                        completionHandler: @escaping(Result<Data, NetworkError>) -> Void) {
        
        guard error == nil else {
            debugPrint(error as Any)
            if let error = error?.localizedDescription {
                completionHandler(.failure(NetworkError.apiError(error)))
            }
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completionHandler(.failure(NetworkError.invalidResponse))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completionHandler(.failure(NetworkError.httpError(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(NetworkError.noData))
            return
        }
        
        completionHandler(.success(data))
    }
}
