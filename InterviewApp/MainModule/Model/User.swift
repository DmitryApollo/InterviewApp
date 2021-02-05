//
//  User.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

struct UserListResponse: Decodable {
    let data: [User]
    var total: Int
}

struct User: Decodable {
    let id: String?
    let title: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let email: String?
    let dateOfBirth: String?
    let registerDate: String?
    let phone: String?
    let picture: String?
    let location: Location?
}

struct Location: Codable {
    let street: String
    let city: String
    let state: String
    let country: String
    let timezone: String
}
