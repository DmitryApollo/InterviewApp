//
//  MainViewModel.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol MainViewModelProtocol {
    var networkService: NetworkServiceProtocol! { get set }
    var users: [User] { get set }
    var totalCount: Int? { get set }
    
    var usersDidChanges: ((Bool, Error?) -> Void)? { get set }
    init(networkService: NetworkServiceProtocol)
    func getUsers(page: Int)
}

final class MainViewModel: MainViewModelProtocol {
    var usersDidChanges: ((Bool, Error?) -> Void)?
    
    var networkService: NetworkServiceProtocol!
    var users: [User] = [] {
        didSet {
            self.usersDidChanges!(true, nil)
        }
    }
    var totalCount: Int?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getUsers(page: Int) {
        networkService.getUsers(page: page) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.totalCount = list.total
                    if page == 1 {
                        self.users = list.data
                    } else {
                        if list.data.isEmpty {
                           return
                        }
                        self.users.append(contentsOf: list.data)
                    }
                    
                case .failure(let error):
                    self.usersDidChanges!(false, error)
                }
            }
        }
    }
}

