//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appRootManager: AppRootManager
    @State private var currentPage: Int = 0
    
    
    var body: some View {
        TabView(selection: $currentPage) {
            // 첫 번째 온보딩 페이지
            VStack {
                Spacer().frame(height: 59)
                
                HStack{
                    Spacer().frame(width: 16)
                    
                    Text("당신을 위한 소리 감지 앱\n히어로드에 오신 걸 환영합니다!")
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
                    
                    Text("히여로는 주행 중 위험 신호를 실시간으로 감지해 시각과 진동으로 알려드립니다.")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 16))
                        .foregroundColor(Color("HGray2"))
                        .frame(width: 295, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 102)
                
                Image(systemName: "circle.fill") // SF Symbols에서 원형 아이콘 사용
                    .resizable()
                    .frame(width: 189, height: 189)
                    .foregroundColor(Color("HPrimaryColor")) // 아이콘 색상 설정
                
                
                Spacer().frame(height: 120)
                
                HStack{
                    Spacer().frame(width: 20)
                    Text("서비스 이용 약관에 동의합니다.")
                        .font(
                            Font.custom("Spoqa Han Sans Neo", size: 16)
                                .weight(.medium)
                        )
                        .foregroundColor(Color("HWhite"))
                    Spacer()
                }
                
                HStack{
                    Spacer().frame(width: 20)
                    Text("히어로 이용약관")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                        .foregroundColor(.white)
                    Text("에 동의하시면 ‘앱 시작하기’를 눌러주세요")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                        .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.54))
                    Spacer()
                }
                
                Spacer().frame(height: 25)
                
                Button(action: {
                    currentPage = 1 // 두 번째 페이지로 전환
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
            .tag(0)
            
            
            // 두 번째 온보딩 페이지
            VStack {
                Text("온보딩 두 번째 페이지")
                    .font(.title)
                    .padding()
            }
            .tag(1)

            // 세 번째 온보딩 페이지
            VStack {
                Text("온보딩 세 번째 페이지")
                    .font(.title)
                    .padding()
            }
            .tag(2)
            
            // 네 번째 온보딩 페이지 (마지막 페이지)
            VStack {
                Text("온보딩 네 번째 페이지")
                    .font(.title)
                    .padding()
                
                // 홈 화면으로 이동하는 버튼
                Button("시작하기") {
                    print("시작하기 버튼")
                    appRootManager.currentRoot = .home // 홈 화면으로 전환
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .tag(3)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
