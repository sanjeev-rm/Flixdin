//
//  Comments.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 26/04/2024.
//

import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    var username: String
    var desc: String
    var replies: [Comment]
    var isRepliesVisible: Bool = false
}

struct CommentsView: View {
    @State private var comments: [Comment] = [
        Comment(username: "JaneDoe", desc: "This is a sample comment.", replies: [
            Comment(username: "JohnSmith", desc: "This is a reply.", replies: []),
        ]),
    ]

    @State var yourComment: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    header()
                    Divider()
                    ForEach($comments) { $comment in
                        commentCell(comment: $comment, indentLevel: 0)
                    }
                }
            }

            Spacer()

            commentBox()
        }
    }
}

#Preview {
    CommentsView()
}

extension CommentsView {
    // MARK: Header

    private func header() -> some View {
        Text("Comments")
            .font(.headline)
            .foregroundColor(.black)
            .padding(.vertical)
    }

    // MARK: Comment Cell

    private func commentCell(comment: Binding<Comment>, indentLevel: Int) -> AnyView {
        AnyView(
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if indentLevel > 0 { Spacer().frame(width: CGFloat(indentLevel * 20)) }
                    Circle()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(comment.username.wrappedValue)
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        Text(comment.desc.wrappedValue)
                            .multilineTextAlignment(.leading)

                        Button(action: {
                            // Add a reply - this will be simplified here
                        }) {
                            Text("Reply")
                                .font(.subheadline)
                                .bold()
                        }
                        .padding(.top, 2)
                        .foregroundColor(Color.gray)

                        if !comment.replies.wrappedValue.isEmpty {
                            Button("Show Replies (\(comment.replies.wrappedValue.count))") {
                                comment.isRepliesVisible.wrappedValue.toggle()
                            }
                            .foregroundColor(Color.blue)
                        }
                    }
                }

                if comment.isRepliesVisible.wrappedValue && !comment.replies.wrappedValue.isEmpty {
                    ForEach(comment.replies.wrappedValue.indices, id: \.self) { index in
                        commentCell(comment: comment.replies[index], indentLevel: indentLevel + 1)
                    }
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        )
    }

    // MARK: Comment Box

    private func commentBox() -> some View {
        HStack {
            TextField("Your Comment", text: $yourComment)
            Image(systemName: "paperplane.fill")
        }
        .padding()
    }
}
