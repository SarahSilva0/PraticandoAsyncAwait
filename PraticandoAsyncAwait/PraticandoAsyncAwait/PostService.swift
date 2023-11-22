//
//  PostService.swift
//  PraticandoAsyncAwait
//
//  Created by Sarah dos Santos Silva on 21/11/23.
//

import Foundation

enum PostError: Error {
    case networkingError
}

struct PostService {
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    func fetchPosts() async throws -> [Post] {
        let (data, _) = try await URLSession.shared.data(from: baseURL)
        return try JSONDecoder().decode([Post].self, from: data)
    }

    func addPost(title: String, body: String) async throws -> Post {
        var newPost = Post(id: 0, title: title, body: body)
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(newPost)

        let (data, _) = try await URLSession.shared.data(from: request.url!)
        return try JSONDecoder().decode(Post.self, from: data)
    }

    func updatePost(post: Post) async throws -> Post {
        let url = baseURL.appendingPathComponent("\(post.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(post)

        let (data, _) = try await URLSession.shared.data(from: request.url!)
        return try JSONDecoder().decode(Post.self, from: data)
    }

    func deletePost(post: Post) async throws {
        let url = baseURL.appendingPathComponent("\(post.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        _ = try await URLSession.shared.data(from: request.url!)
    }
}
