//
//  HomeView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Spacer().frame(height: 89)
            
            HStack{
                Spacer().frame(width: 16)
                
                Text("안녕하세요!\n오늘도 안전한 주행 되세요.")
                    .font(
                        Font.custom("Spoqa Han Sans Neo", size: 25)
                            .weight(.bold)
                    )
                    .foregroundColor(Color("HWhite"))
                
                Spacer()
            }
            
            Spacer().frame(height: 19)
            
            HStack{
                Spacer().frame(width: 16)
                
                Text("2024. 09. 22  화요일")
                    .font(Font.custom("Spoqa Han Sans Neo", size: 18))
                    .foregroundColor(Color("HGray2"))
                    .frame(width: 295, alignment: .topLeading)
                
                Spacer()
            }
            
            Spacer().frame(height: 105)
            
            Image(systemName: "circle.fill") // SF Symbols에서 원형 아이콘 사용
                .resizable()
                .frame(width: 189, height: 189)
                .foregroundColor(Color("HPrimaryColor")) // 아이콘 색상 설정
            
            
            Spacer().frame(height: 236)
            
            Button(action: {
                appRootManager.currentRoot = .working
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 361, height: 58)
                        .background(Color.white)
                        .cornerRadius(10)
                        .opacity(0.28)
                    
                    Text("시작하기")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}
