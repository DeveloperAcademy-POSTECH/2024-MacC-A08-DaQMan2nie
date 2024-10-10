//
//  WorkingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import SwiftUI

struct WorkingView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Text("워킹 화면")
                .font(.largeTitle)
                .padding()
            Button(action: {
                appRootManager.currentRoot = .finish
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 361, height: 58)
                        .background(Color.white)
                        .cornerRadius(10)
                        .opacity(0.28)
                    
                    Text("종료하기")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}
