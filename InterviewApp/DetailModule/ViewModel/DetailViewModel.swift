//
//  DetailViewModel.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol {
    var networkService: NetworkServiceProtocol! { get set }
    var userId: String { get set }
    var user: User? { get set }
    
    var userDidChanges: ((Bool, Error?) -> Void)? { get set }
    init(userId: String, networkService: NetworkServiceProtocol)
    func getUserInfo(id: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    var networkService: NetworkServiceProtocol!
    var user: User? {
        didSet {
            self.userDidChanges!(true, nil)
        }
    }
    
    var userId: String
    var userDidChanges: ((Bool, Error?) -> Void)?
    
    init(userId: String, networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.userId = userId
    }
    
    func getUserInfo(id: String) {
        networkService.getUserInfo(id: id) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.userDidChanges!(false, error)
                }
            }
        }
    }
}
