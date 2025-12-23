import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var appearAnimation = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "020617").ignoresSafeArea()
            LiquidBackground()
            
            // Root Liquid Glass Container
            if #available(iOS 18.0, visionOS 2.0, *) {
                GlassEffectContainer(spacing: 30) {
                    infoContent
                }
            } else {
                infoContent
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .glassEffect(in: .circle)
                    .padding()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                appearAnimation = true
            }
        }
    }
    
    @ViewBuilder
    private var infoContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .frame(width: 150, height: 150)
                            .glassEffect()
                            .glassShimmer(animate: true)
                        
                        AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.2))
                        }
                        .frame(width: 135, height: 135)
                        .clipShape(Circle())
                    }
                    .scaleEffect(appearAnimation ? 1.0 : 0.9)
                    .shadow(color: .blue.opacity(0.3), radius: 30, x: 0, y: 15)
                    
                    VStack(spacing: 8) {
                        Text("ねずみ")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("@nezumi0627")
                            .font(.system(.headline, design: .monospaced))
                            .foregroundColor(.cyan)
                    }
                }
                .padding(.top, 40)
                
                // Title Badge
                Text("高校生開発者 / iOS Engineer")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect()
                
                // Content Grid
                VStack(spacing: 16) {
                    ProfileInfoCard(title: "Location", value: "Fukuoka, Japan", icon: "location.fill", color: .red)
                    ProfileInfoCard(title: "Language", value: "Swift, TS, Python", icon: "terminal.fill", color: .green)
                    ProfileInfoCard(title: "Interests", value: "IPA Injection, UI/UX", icon: "sparkles", color: .orange)
                }
                .padding(.horizontal, 24)
                
                // Social Links
                VStack(alignment: .leading, spacing: 20) {
                    Text("CONNECT")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.leading, 8)
                    
                    VStack(spacing: 12) {
                        SocialLinkItem(title: "GitHub", icon: "github.fill", color: .white, url: "https://github.com/nezumi0627")
                        SocialLinkItem(title: "X (Twitter)", icon: "bird.fill", color: Color(hex: "1DA1F2"), url: "https://x.com/nezum1n1um")
                        SocialLinkItem(title: "Discord", icon: "bubble.left.and.bubble.right.fill", color: Color(hex: "5865F2"), url: "https://discord.com/users/1248909552171221027")
                        SocialLinkItem(title: "Wishlist", icon: "gift.fill", color: .pink, url: "https://www.amazon.jp/hz/wishlist/ls/11OOP56XMJPUA?ref_=wl_share")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ProfileInfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
                Text(value)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 20))
        .glassShimmer(animate: true)
    }
}

struct SocialLinkItem: View {
    let title: String
    let icon: String
    let color: Color
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .glassEffect(in: .rect(cornerRadius: 20))
        }
    }
}
