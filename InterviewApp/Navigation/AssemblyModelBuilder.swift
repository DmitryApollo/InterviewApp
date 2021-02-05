//
//  AssemblyModelBuilder.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol AssemblyModelBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(userId: String, router: RouterProtocol) -> UIViewController
    func createLocationModule(location: Location) -> UIViewController
    func createPostsModule(userId: String) -> UIViewController
}

class AssemblyModelBuilder: AssemblyModelBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        view.viewModel = MainViewModel(networkService: networkService)
        view.router = router
        return view
    }
    
    func createDetailModule(userId: String, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        view.viewModel = DetailViewModel(userId: userId, networkService: networkService)
        view.router = router
        return view
    }
    
    func createLocationModule(location: Location) -> UIViewController {
        let view = LocationViewController()
        view.viewModel = LocationViewModel(location: location)
        return view
    }
    
    func createPostsModule(userId: String) -> UIViewController {
        let view = PostsViewController()
        let networkService = NetworkService()
        view.viewModel = PostsViewModel(networkService: networkService, userId: userId)
        return view
    }
    
}
