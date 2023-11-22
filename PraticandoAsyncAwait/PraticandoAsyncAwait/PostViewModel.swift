//
//  PostViewModel.swift
//  PraticandoAsyncAwait
//
//  Created by Sarah dos Santos Silva on 22/11/23.
//

import Foundation

class PostViewModel: ObservableObject {
    private let postService = PostService()

    @Published var posts: [Post] = []

    func fetchPosts() async {
        do {
            self.posts = try await postService.fetchPosts()
        } catch {
            print("Error fetching posts: \(error)")
        }
    }

    func addPost(title: String, body: String) async {
        do {
            let newPost = try await postService.addPost(title: title, body: body)
            self.posts.append(newPost)
        } catch {
            print("Error adding post: \(error)")
        }
    }

    func updatePost(post: Post) async {
        do {
            let updatedPost = try await postService.updatePost(post: post)
            if let index = self.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                self.posts[index] = updatedPost
            }
        } catch {
            print("Error updating post: \(error)")
        }
    }

    func deletePost(post: Post) async {
        do {
            try await postService.deletePost(post: post)
            self.posts.removeAll { $0.id == post.id }
        } catch {
            print("Error deleting post: \(error)")
        }
    }
}
