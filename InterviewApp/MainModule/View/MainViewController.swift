//
//  MainViewController.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModelProtocol!
    var router: RouterProtocol!
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    private var isLoading: Bool = false
    private var page: Int = 1
    private var isRequestSuccessful: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        prepareViewModelObserver()
        viewModel.getUsers(page: page)
    }
    
    private func setUpUI() {
        title = "Users"
        view.backgroundColor = .black
        setUpTableView()
        setUpActivityIndicator()
    }
    
    private func prepareViewModelObserver() {
        viewModel.usersDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let error = error {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                self.errorAlert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                guard let errorAlert = self.errorAlert else { return }
                self.present(errorAlert, animated: true)
                self.isLoading = false
                self.isRequestSuccessful = false
                return
            }
            
            if finished {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
                self.isLoading = false
                self.isRequestSuccessful = true
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        
        let user = viewModel.users[indexPath.row]
        cell.titleLabel.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        
        if let urlString = user.picture, let url = URL(string: urlString) {
            cell.userImageView.loadImage(fromURL: url)
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoading, let totalCount = viewModel.totalCount else { return }
        
        if totalCount > 20,
            indexPath.row == viewModel.users.count - 1,
            viewModel.users.count < totalCount {
            isLoading = true
            
            if isRequestSuccessful {
                page += 1
                isRequestSuccessful = false
            }
        
            viewModel.getUsers(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let userId = viewModel.users[indexPath.row].id else { return }
        router.showDetail(userId: userId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

//MARK: Set Up UI

extension MainViewController {
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "mainCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint])
        activityIndicator.startAnimating()
    }
}
