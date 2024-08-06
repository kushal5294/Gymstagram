import SwiftUI
import Kingfisher

struct PostView: View {
    var post: Post
    @State private var isLiked: Bool = false
    @State private var postOwner: User? = nil
    @State private var showLikeAnimation: Bool = false
    @State private var likeCount: Int = 0
    @EnvironmentObject var viewModel: AuthViewModel
    private let userService = UserService()
    private let postService = PostService()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let owner = postOwner {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 23))
                        Text(owner.username)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                } else {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 23))
                        Text("Loading...")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                
                Spacer()
                Text("\(post.timestamp.dateValue().timeSince())")
                    .padding(.trailing, 10)
            }
            
            ZStack {
                KFImage(URL(string: post.imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
                    .onTapGesture(count: 2) {
                        handleDoubleTapLike()
                    }
                
                if showLikeAnimation {
                    GeometryReader { geometry in
                        Image(systemName: "heart.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.blue)
                            .scaleEffect(showLikeAnimation ? 1.0 : 0.5)
                            .opacity(showLikeAnimation ? 1.0 : 0.0)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .animation(Animation.spring(response: 1.0, dampingFraction: 0.4, blendDuration: 0.5), value: showLikeAnimation)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showLikeAnimation = false
                                }
                            }
                    }
                }
            }
            
            Text(post.caption)
                .font(.body)
                .padding(.horizontal, 10)
                .padding(.top, 8)
            
            HStack {
                Button(action: {
                    handleLike()
                }, label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 34))
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                })
                
                Text("\(likeCount) likes") // Display like count
                    .font(.body)
                    .padding(.horizontal, 10)
                
                TagView(tags: post.tags)
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 8)
        .onAppear {
            userService.fetchUser(withUid: post.uid) { user in
                postOwner = user
            }
            Task {
                if let usr = viewModel.currentUser {
                    let liked = await postService.isLiked(likerUid: usr.id!, postID: post.id!)
                    self.isLiked = liked
                }
                likeCount = await postService.fetchLikeCount(forPostID: post.id!)
            }
        }
    }
    
    private func handleLike() {
        isLiked.toggle()
        Task {
            if let usr = viewModel.currentUser {
                await postService.handleLike(likerUid: usr.id!, postID: post.id!)
                // Update like count after handling like
                likeCount = await postService.fetchLikeCount(forPostID: post.id!)
            }
        }
    }
    
    private func handleDoubleTapLike() {
        if (!isLiked) {
            handleLike()
        }
        withAnimation {
            showLikeAnimation = true
        }
    }
}
