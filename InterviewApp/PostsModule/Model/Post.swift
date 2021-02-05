//
//  Post.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

struct PostListResponse: Decodable {
    let data: [Post]
    var total: Int
}

struct Post: Decodable {
    let text: String?
    let image: String?
    let likes: Int?
    let link: String?
    let tags: [String]?
    let publishDate: String?
    let owner: User?
}
