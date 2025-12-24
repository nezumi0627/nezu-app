import SwiftUI

/// Infoタブ用のシンプルなLiquid Glassレイアウト
struct InfoView: View {
    var body: some View {
        ScrollView {
            GlassEffectContainer {
                VStack(spacing: 20) {
                    // プロフィールカード
                    GlassEffectContainer {
                        VStack(spacing: 14) {
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
                            .glassEffect(.interactive, in: Circle())
                            
                            VStack(spacing: 4) {
                                Text("nezumi")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                                
                                Text("@nezumi0627")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text("Developer ・ Web Analyst ・ Python Enthusiast")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 16)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    // シンプルな情報カード
                    GlassEffectContainer {
                        VStack(spacing: 10) {
                            InfoRow(label: "Birthday", value: "2008-06-27", systemName: "calendar")
                            InfoRow(label: "Location", value: "Kitakyushu, Fukuoka", systemName: "location")
                            InfoRow(label: "Languages", value: "Japanese / English", systemName: "globe")
                            InfoRow(label: "Skills", value: "Swift, TypeScript, Python", systemName: "hammer")
                        }
                        .padding(16)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    // リンク群
                    GlassEffectContainer {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Links")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.secondary)
                            
                            VStack(spacing: 8) {
                                InfoLink(title: "GitHub", url: "https://github.com/nezumi0627")
                                InfoLink(title: "X (Twitter)", url: "https://x.com/nezum1n1um")
                                InfoLink(title: "Discord", url: "https://discord.com/users/1248909552171221027")
                            }
                        }
                        .padding(16)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    let systemName: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 18)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
    }
}

private struct InfoLink: View {
    let title: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}
