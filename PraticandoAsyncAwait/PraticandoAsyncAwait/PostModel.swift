//
//  PostModel.swift
//  PraticandoAsyncAwait
//
//  Created by Sarah dos Santos Silva on 21/11/23.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    var title: String
    var body: String
}
