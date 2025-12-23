//
//  ContentView.swift
//  test-app
//
//  Created by GitHub Actions
//

import SwiftUI

struct ContentView: View {
    @State private var counter = 0
    @State private var showUpdateView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Nezu App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("カウンター: \(counter)")
                    .font(.title2)
                
                Button(action: {
                    counter += 1
                }) {
                    Text("カウントアップ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    counter = 0
                }) {
                    Text("リセット")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Nezu App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showUpdateView = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showUpdateView) {
                NavigationView {
                    UpdateCheckView()
                        .navigationTitle("バージョン情報")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("閉じる") {
                                    showUpdateView = false
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

