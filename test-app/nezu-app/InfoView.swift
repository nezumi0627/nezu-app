import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "020617").ignoresSafeArea()
                LiquidBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.ultraThinMaterial, lineWidth: 2))
                            
                            Text("ねずみ")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text("@nezumi0627")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(.secondary)
                            
                            Text("高校生開発者 / iOS Engineer")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .glassEffect(in: Capsule())
                        }
                        .padding(.top, 40)
                        
                        // Info cards
                        VStack(spacing: 12) {
                            InfoCard(title: "Location", value: "Fukuoka, Japan", icon: "location")
                            InfoCard(title: "Languages", value: "Swift, TypeScript, Python", icon: "code")
                            InfoCard(title: "Interests", value: "IPA Injection, UI/UX", icon: "sparkles")
                        }
                        .padding(.horizontal, 20)
                        
                        // Social links
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Links")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 8) {
                                SocialLink(title: "GitHub", icon: "link", url: "https://github.com/nezumi0627")
                                SocialLink(title: "X (Twitter)", icon: "link", url: "https://x.com/nezum1n1um")
                                SocialLink(title: "Discord", icon: "link", url: "https://discord.com/users/1248909552171221027")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SocialLink: View {
    let title: String
    let icon: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .glassEffect(in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
