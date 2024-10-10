//
//  NetworkManager.swift
//  Student App
//
//  Created by Arjun   on 14/07/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getRequest(url: URL,  completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Pass data as nil if 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
            } else {
                completion(.success((data, httpResponse)))
            }
        }.resume()
    }
    
    func getRequest(url: URL, params: [String: String], authToken: String? = nil, completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        if let authToken = authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Pass data as nil if 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
            } else {
                completion(.success((data, httpResponse)))
            }
        }.resume()
    }
    
    
    func postRequest(url: URL, queryParams: [String: String], completion: @escaping (Result<(Bool?, HTTPURLResponse), Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode ?? -1
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Handle 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
                return
            }

            // Decode the JSON response
            guard let data = data else {
                completion(.success((nil, httpResponse)))
                return
            }

            do {
                let result = try JSONDecoder().decode(Bool.self, from: data)
                completion(.success((result, httpResponse)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func postRequest(url: URL, body: Data, authToken: String? = nil, completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Pass data as nil if 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
            } else {
                completion(.success((data, httpResponse)))
            }
        }.resume()
    }
    
    func putRequest(url: URL, body: Data, authToken: String? = nil, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success((data, httpResponse)))
        }.resume()
    }

    func postRequest(url: URL, completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Pass data as nil if 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
            } else {
                completion(.success((data, httpResponse)))
            }
        }.resume()
    }
    
    func sendPostRequest<T: Encodable>(to url: URL, with body: T, completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let httpResponse = response as? HTTPURLResponse
                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            // Pass data as nil if 204 No Content
            if httpResponse.statusCode == 204 {
                completion(.success((nil, httpResponse)))
            }  else {
                completion(.success((data, httpResponse)))
            }
        }.resume()
    }

}
