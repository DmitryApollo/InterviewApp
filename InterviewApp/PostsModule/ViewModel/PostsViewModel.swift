//
//  PostsViewModel.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol PostsViewModelProtocol {
    var networkService: NetworkServiceProtocol! { get set }
    var posts: [Post] { get set }
    var totalCount: Int? { get set }
    
    var postsDidChanges: ((Bool, Error?) -> Void)? { get set }
    init(networkService: NetworkServiceProtocol, userId: String)
    func getPosts(page: Int)
}

final class PostsViewModel: PostsViewModelProtocol {
    var postsDidChanges: ((Bool, Error?) -> Void)?
    
    var networkService: NetworkServiceProtocol!
    var posts: [Post] = [] {
        didSet {
            self.postsDidChanges!(true, nil)
        }
    }
    var totalCount: Int?
    var userId: String
    
    init(networkService: NetworkServiceProtocol, userId: String) {
        self.networkService = networkService
        self.userId = userId
    }
    
    func getPosts(page: Int) {
        networkService.getUserPosts(page: page, id: userId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.totalCount = list.total
                    if page == 1 {
                        self.posts = list.data
                    } else {
                        if list.data.isEmpty {
                           return
                        }
                        self.posts.append(contentsOf: list.data)
                    }
                    
                case .failure(let error):
                    self.postsDidChanges!(false, error)
                }
            }
        }
    }
}
