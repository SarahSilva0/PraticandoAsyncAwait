//
//  ContentView.swift
//  PraticandoAsyncAwait
//
//  Created by Sarah dos Santos Silva on 21/11/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = PostViewModel()
    @State private var newPostTitle = ""
    @State private var newPostBody = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.posts) { post in
                    NavigationLink(destination: PostDetail(post: post, viewModel: viewModel)) {
                        Text(post.title)
                    }
                }
                .onDelete { indexSet in
                    let postToDelete = viewModel.posts[indexSet.first!]
                    Task {
                        await viewModel.deletePost(post: postToDelete)
                    }
                }
            }
            .navigationTitle("Posts")
            .navigationBarItems(trailing: NavigationLink(destination: AddPostView(viewModel: viewModel)) {
                Image(systemName: "plus")
            })
        }
        .onAppear {
            Task {
                await viewModel.fetchPosts()
            }
        }
    }
}

struct AddPostView: View {
    @ObservedObject var viewModel: PostViewModel
    @State private var newPostTitle = ""
    @State private var newPostBody = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section {
                TextField("Título", text: $newPostTitle)
                TextField("Corpo", text: $newPostBody)
            }

            Section {
                Button("Adicionar") {
                    Task {
                        await viewModel.addPost(title: newPostTitle, body: newPostBody)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationTitle("Nova Postagem")
    }
}

struct PostDetail: View {
    @State var post: Post
    @ObservedObject var viewModel: PostViewModel

    var body: some View {
        Form {
            Section {
                TextField("Título", text: $post.title)
                TextField("Corpo", text: $post.body)
            }

            Section {
                Button("Salvar Alterações") {
                    Task {
                        await viewModel.updatePost(post: post)
                    }
                }
            }
        }
        .navigationTitle("Detalhes do Post")
    }
}


#Preview {
    ContentView()
}
