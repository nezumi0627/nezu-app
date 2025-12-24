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
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 16) {
                                AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 48))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .glassEffect(.interactive, in: Circle())
                                
                                VStack(spacing: 4) {
                                    Text("nezumi")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.primary)
                                    
                                    Text("@nezumi0627")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.secondary)
                                }
                                
                                HStack(spacing: 8) {
                                    Text("Developer")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text("•")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.tertiary)
                                    Text("Web Analyst")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text("•")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.tertiary)
                                    Text("Python Enthusiast")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .glassEffect(.interactive, in: Capsule())
                            }
                            .padding(.top, 32)
                            
                            // Info cards
                            VStack(spacing: 12) {
                                InfoCard(title: "Birthday", value: "2008年6月27日", icon: "calendar")
                                InfoCard(title: "Location", value: "福岡県北九州市", icon: "location")
                                InfoCard(title: "Languages", value: "日本語と英語", icon: "globe")
                                InfoCard(title: "Skills", value: "Swift, TypeScript, Python", icon: "code")
                            }
                            .padding(.horizontal, 20)
                            
                            // Social links
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Links")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 4)
                                
                                VStack(spacing: 10) {
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .symbolVariant(.none)
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: 32)
                            .glassEffect(.interactive, in: Circle())
                    }
                    .contentShape(Circle())
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
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .symbolVariant(.none)
                .foregroundStyle(.secondary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding(18)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
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
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .medium))
                    .symbolVariant(.none)
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
        }
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}
