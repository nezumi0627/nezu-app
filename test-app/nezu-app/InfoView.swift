import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "020617").ignoresSafeArea()
                LiquidBackground()
                
                ScrollView {
                    GlassEffectContainer {
                        VStack(spacing: 24) {
                            // Profile Image
                            AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .glassEffect(.interactive, in: Circle())
                            .padding(.top, 32)
                            
                            // Name and ID
                            VStack(spacing: 8) {
                                Text("ねずみ")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                Text("@nezumi0627")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.secondary)
                            }
                            
                            // Title
                            Text("高校生開発者")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .glassEffect(.interactive, in: Capsule())
                            
                            // Profile Info
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.red)
                                        .frame(width: 24)
                                    Text("Japanese, Fukuoka")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(.primary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "birthday.cake.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.pink)
                                        .frame(width: 24)
                                    Text("2008/06/27")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(.primary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 20)
                            
                            // Link Buttons
                            VStack(spacing: 12) {
                                LinkButton(
                                    title: "X (Twitter)",
                                    icon: "bird.fill",
                                    url: "https://x.com/nezum1n1um",
                                    color: .black
                                )
                                
                                LinkButton(
                                    title: "GitHub Pages",
                                    icon: "globe",
                                    url: "https://nezumi0627.github.io/",
                                    color: .blue
                                )
                                
                                LinkButton(
                                    title: "Discord",
                                    icon: "message.fill",
                                    url: "https://discord.com/users/1248909552171221027",
                                    color: .purple
                                )
                                
                                LinkButton(
                                    title: "Amazon ほしいものリスト",
                                    icon: "cart.fill",
                                    url: "https://www.amazon.jp/hz/wishlist/ls/11OOP56XMJPUA?ref_=wl_share",
                                    color: .orange
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

struct LinkButton: View {
    let title: String
    let icon: String
    let url: String
    let color: Color
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .symbolVariant(.none)
                    .foregroundStyle(.white)
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square")
                    .font(.system(size: 14, weight: .medium))
                    .symbolVariant(.none)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(18)
            .background(color)
            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
        }
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}
