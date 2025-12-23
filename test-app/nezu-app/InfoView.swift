//
//  InfoView.swift
//  nezu-app
//
//  Created by GitHub Actions
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // プロフィール画像
                AsyncImage(url: URL(string: "https://github.com/nezumi0627.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                .shadow(radius: 5)
                .padding(.top, 20)
                
                // 名前とID
                VStack(spacing: 8) {
                    Text("ねずみ")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("@nezumi0627")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // 肩書
                Text("高校生開発者")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                
                // プロフィール情報
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                        Text("Japanese, Fukuoka")
                    }
                    
                    HStack {
                        Image(systemName: "birthday.cake.fill")
                            .foregroundColor(.pink)
                        Text("2008/06/27")
                    }
                }
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // リンクボタン
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
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
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
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding()
            .background(color)
            .cornerRadius(10)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

