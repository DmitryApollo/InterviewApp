//
//  Router.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModelBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(userId: String)
    func showLocation(location: Location)
    func showPosts(userId: String)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModelBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModelBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navController = navigationController {
            guard let repoVC = assemblyBuilder?.createMainModule(router: self) else { return }
            navController.viewControllers = [repoVC]
        }
    }
    
    func showDetail(userId: String) {
        if let navController = navigationController {
            guard let detailVC = assemblyBuilder?.createDetailModule(userId: userId, router: self) else { return }
            detailVC.modalPresentationCapturesStatusBarAppearance = true
            navController.pushViewController(detailVC, animated: true)
        }
    }
    
    func showLocation(location: Location) {
        if let navController = navigationController {
            guard let locationVC = assemblyBuilder?.createLocationModule(location: location) else { return }
            locationVC.modalPresentationStyle = .automatic
            navController.pushViewController(locationVC, animated: true)
        }
    }
    
    func showPosts(userId: String) {
        if let navController = navigationController {
            guard let postsVC = assemblyBuilder?.createPostsModule(userId: userId) else { return }
            postsVC.modalPresentationStyle = .automatic
            navController.pushViewController(postsVC, animated: true)
        }
    }
}
