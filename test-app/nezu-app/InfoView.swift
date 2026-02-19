//
//  InfoView.swift
//  nezu-app
//
//  開発者情報とリンク集。
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .glassEffect(in: .circle)

                        Text("ねずみ")
                            .font(.title2.bold())
                        Text("@nezumi0627")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 24)

                    // Profile details
                    VStack(spacing: 0) {
                        ProfileRow(icon: "location.fill", color: .red, text: "Fukuoka, Japan")
                        Divider().padding(.leading, 52)
                        ProfileRow(icon: "birthday.cake.fill", color: .pink, text: "2008/06/27")
                        Divider().padding(.leading, 52)
                        ProfileRow(icon: "studentdesk", color: .blue, text: "高校生開発者")
                    }
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 20)

                    // Links
                    VStack(spacing: 10) {
                        LinkRow(title: "X (Twitter)", icon: "bird.fill", url: "https://x.com/nezum1n1um")
                        LinkRow(title: "GitHub Pages", icon: "globe", url: "https://nezumi0627.github.io/")
                        LinkRow(title: "Discord", icon: "message.fill", url: "https://discord.com/users/1248909552171221027")
                        LinkRow(title: "Amazon ほしいものリスト", icon: "cart.fill", url: "https://www.amazon.jp/hz/wishlist/ls/11OOP56XMJPUA?ref_=wl_share")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("情報")
        }
    }
}

// MARK: - Components

struct ProfileRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 28)
            Text(text)
                .font(.body)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct LinkRow: View {
    let title: String
    let icon: String
    let url: String

    var body: some View {
        if let linkURL = URL(string: url) {
            Link(destination: linkURL) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .frame(width: 28)
                    Text(title)
                        .font(.body.weight(.medium))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .glassEffect(.interactive, in: .rect(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    InfoView()
}
