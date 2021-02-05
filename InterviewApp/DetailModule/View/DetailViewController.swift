//
//  DetailViewController.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var viewModel: DetailViewModelProtocol!
    var router: RouterProtocol!
    
    private let tableView = UITableView()
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let locationButton = UIButton()
    private let commentsButton = UIButton()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        prepareViewModelObserver()
        viewModel.getUserInfo(id: viewModel.userId)
    }
    
    private func setUpUI() {
        setUpImageView()
        setUpButtons()
        setUpTableView()
        setUpActivityIndicator()
    }
    
    @objc private func locationButtonClicked() {
        guard let location = viewModel.user?.location else { return }
        router.showLocation(location: location)
    }
    
    @objc private func commentsButtonClicked() {
        router.showPosts(userId: viewModel.userId)
    }
    
    private func prepareViewModelObserver() {
        viewModel.userDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let error = error {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                self.errorAlert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                guard let errorAlert = self.errorAlert else { return }
                self.present(errorAlert, animated: true)
                return
            }
            
            if finished {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
                
                guard let urlString = self.viewModel.user?.picture, let url = URL(string: urlString) else { return }
                self.imageView.loadImage(fromURL: url)
            }
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let user = viewModel.user
        switch indexPath.row {
        case 0:
            cell.subtitleLabel.text = "First Name"
            cell.titleLabel.text = user?.firstName
        case 1:
            cell.subtitleLabel.text = "Last Name"
            cell.titleLabel.text = user?.lastName
        case 2:
            cell.subtitleLabel.text = "Gender"
            cell.titleLabel.text = user?.gender
        case 3:
            cell.subtitleLabel.text = "Date of birth"

            if let date = user?.dateOfBirth {
                let df = DateFormatter()
                df.dateFormat = "MM-dd-yyyy"
                cell.titleLabel.text = date
            }
        case 4:
            cell.subtitleLabel.text = "E-mail"
            cell.titleLabel.text = user?.email
        case 5:
            cell.subtitleLabel.text = "Phone"
            cell.titleLabel.text = user?.phone
        default:
            break
        }
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

//MARK: Set Up UI

extension DetailViewController {
    private func setUpImageView() {
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraintImageView = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 24)
        let trailingConstraintImageView = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -24)
        let topConstraintImageView = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: 8)
        let heightConstraintImageView = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 224)
        
        view.addConstraints([leadingConstraintImageView, trailingConstraintImageView, topConstraintImageView, heightConstraintImageView])
    }
    
    private func setUpButtons() {
        view.addSubview(stackView)
        
        view.backgroundColor = .black
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraintButtonsView = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraintButtonsView = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let bottomConstraintButtonsView = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: 0)
        let heightConstraintButtonsView = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 48)
        
        view.addConstraints([leadingConstraintButtonsView, trailingConstraintButtonsView, bottomConstraintButtonsView, heightConstraintButtonsView])
        
        stackView.addArrangedSubview(locationButton)
        stackView.addArrangedSubview(commentsButton)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        locationButton.setTitle("Show location", for: .normal)
        commentsButton.setTitle("Show comments", for: .normal)
        
        locationButton.titleLabel?.textAlignment = .center
        commentsButton.titleLabel?.textAlignment = .center
        
        locationButton.backgroundColor = .orange
        commentsButton.backgroundColor = .orange
        
        locationButton.layer.cornerRadius = 10
        commentsButton.layer.cornerRadius = 10
        
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        commentsButton.addTarget(self, action: #selector(commentsButtonClicked), for: .touchUpInside)
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 8)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: stackView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
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
