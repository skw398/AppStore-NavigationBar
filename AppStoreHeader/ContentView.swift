//
//  ContentView.swift
//  AppStoreHeader
//
//  Created by Shigenari Oshio on 2022/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isGetButtonOverNav = false
    
    var body: some View {
        NavigationView {
            GeometryReader { scrollViewGeo in
                ScrollView {
                    HStack {
                        Image("SwiftLogo")
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Swift")
                                .font(.title)
                            
                            Text("Apple")
                                .foregroundColor(.gray)
                            
                            HStack {
                                Button(action: {}) {
                                    getButton
                                        .background(GeometryReader { geo in
                                                Color.clear.preference(
                                                    key: GetButtonMinXPreferenceKey.self,
                                                    value: geo.frame(in: .global).minY
                                                )
                                            })
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                    }
                    .opacity(isGetButtonOverNav ? 0 : 1)
                    .animation(.easeInOut(duration: 0.25), value: isGetButtonOverNav)
                    .padding(.horizontal)
                    
                    ForEach(0..<10) { _ in
                        Text("Detail Content")
                            .foregroundColor(.gray)
                            .frame(height: 100)
                    }
                }
                .onPreferenceChange(GetButtonMinXPreferenceKey.self) {
                    isGetButtonOverNav = $0 < scrollViewGeo.frame(in: .global).minY
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image("SwiftLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .modifier(ShowNavItemWithAnimation(isShowing: isGetButtonOverNav))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        getButton
                    }
                    .modifier(ShowNavItemWithAnimation(isShowing: isGetButtonOverNav))
                }
            }
        }
    }
    
    private var getButton: some View {
        Text("GET")
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 80, height: 30)
            .background(.blue)
            .cornerRadius(15)
    }
    
    private struct GetButtonMinXPreferenceKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
    
    private struct ShowNavItemWithAnimation: ViewModifier {
        let isShowing: Bool
        func body(content: Content) -> some View {
            content
                .opacity(isShowing ? 1 : 0)
                .offset(y: isShowing ? 0 : 5)
                .animation(.easeInOut(duration: 0.25), value: isShowing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
