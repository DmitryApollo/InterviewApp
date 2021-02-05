//
//  NetworkService.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getUsers(page: Int, completion: @escaping (Result<UserListResponse, Error>) -> Void)
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void)
    func getUserPosts(page: Int, id: String, completion: @escaping (Result<PostListResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func getUsers(page: Int, completion: @escaping (Result<UserListResponse, Error>) -> Void) {
        var comp = getComponents()
        comp.path = "/data/api/user"
        comp.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = comp.url else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        let request = makeRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(UserListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        var comp = getComponents()
        comp.path = "/data/api/user/\(id)"
        
        guard let url = comp.url else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        let request = makeRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(User.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getUserPosts(page: Int, id: String, completion: @escaping (Result<PostListResponse, Error>) -> Void) {
        var comp = getComponents()
        comp.path = "/data/api/user/\(id)/post"
        comp.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = comp.url else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        let request = makeRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(PostListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getComponents() -> URLComponents {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "dummyapi.io"
        return comp
    }
    
    private func makeRequest(url: URL) -> URLRequest {
        let accessKey = "601db0b4bc0c57de2e10e4be"
        var request = URLRequest(url: url)
        request.addValue(accessKey, forHTTPHeaderField: "app-id")
        return request
    }
}
