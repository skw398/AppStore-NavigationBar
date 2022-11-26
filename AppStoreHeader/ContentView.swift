//
//  ContentView.swift
//  AppStoreHeader
//
//  Created by Shigenari Oshio on 2022/11/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var getButtonReachedTheTop = false
    
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
                                                    key: getButtonMinXPreferenceKey.self,
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
                    .opacity(getButtonReachedTheTop ? 0 : 1)
                    .animation(.easeInOut(duration: 0.25), value: getButtonReachedTheTop)
                    .padding(.horizontal)
                    
                    ForEach(0..<10) { _ in
                        Text("Detail Content")
                            .foregroundColor(.gray)
                            .frame(height: 100)
                    }
                }
                .onPreferenceChange(getButtonMinXPreferenceKey.self) {
                    getButtonReachedTheTop = $0 < scrollViewGeo.frame(in: .global).minY
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
                        .modifier(appearsByScrolling(shouldAppear: getButtonReachedTheTop))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        getButton
                    }
                    .modifier(appearsByScrolling(shouldAppear: getButtonReachedTheTop))
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
    
    private struct getButtonMinXPreferenceKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
    
    private struct appearsByScrolling: ViewModifier {
        let shouldAppear: Bool
        func body(content: Content) -> some View {
            content
                .opacity(shouldAppear ? 1 : 0)
                .offset(y: shouldAppear ? 0 : 5)
                .animation(.easeInOut(duration: 0.25), value: shouldAppear)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
