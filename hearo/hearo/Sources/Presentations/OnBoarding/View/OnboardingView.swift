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
                    
                    Text("히여로는 주행 중 위험 신호를 실시간으로 감지해\n시각과 진동으로 알려드립니다.")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
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
                Spacer().frame(height: 59)
                
                HStack{
                    Spacer().frame(width: 16)
                    
                    Text("경적 소리 감지시\n안전을 위한 알림을 허용하세요")
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
                    
                    Text("안전한 주행을 위해,주행 중 경적, 사이렌 소리 등\n중요한 경고 신호를 놓치지 않도록 알림을 허용해 주세요.")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                        .foregroundColor(Color("HGray2"))
                        .frame(width: 295, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 139)
                
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 138.34453, height: 161.72163)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 121.28)
                
                HStack(spacing: 4) {
                                ForEach(1..<4) { index in // 2, 3, 4 페이지 인디케이터
                                    Circle()
                                        .fill(currentPage == index ? Color.white : Color.gray) // 현재 페이지에 따라 색상 조정
                                        .frame(width: 8, height: 8)
                                }
                            }
                Spacer().frame(height: 51)
                
                Button(action: {
                    currentPage = 2
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 361, height: 58)
                            .background(Color.white)
                            .cornerRadius(10)
                            .opacity(0.28)
                        
                        Text("확인")
                            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .tag(1)

            // 세 번째 온보딩 페이지
            VStack {
                Spacer().frame(height: 59)
                
                HStack{
                    Spacer().frame(width: 19)
                    
                    Text("경적 소리 감지시\n안전을 위한 알림을 허용하세요")
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
                    
                    Text("녹음된 오디오는 오직 경적 소리 인식 목적으로만 \n사용됩니다.\n\n녹음 데이터는 저장되지 않으며, 실시간으로 분석 후 즉시 삭제됩니다. \n\n사용자의 다른 행동이나 대화는 절대 녹음되지 않습니다.")
                      .font(Font.custom("Spoqa Han Sans Neo", size: 14))
                      .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                      .frame(width: 345, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 64)
                
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .frame(width: 122.39725, height: 164.59821)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 110)
                
                HStack(spacing: 4) {
                                ForEach(1..<4) { index in // 2, 3, 4 페이지 인디케이터
                                    Circle()
                                        .fill(currentPage == index ? Color.white : Color.gray) // 현재 페이지에 따라 색상 조정
                                        .frame(width: 8, height: 8)
                                }
                            }
                Spacer().frame(height: 51)
                
                Button(action: {
                    currentPage = 3
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 361, height: 58)
                            .background(Color.white)
                            .cornerRadius(10)
                            .opacity(0.28)
                        
                        Text("확인")
                            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
            }
            .tag(2)
            
            // 네 번째 온보딩 페이지
            VStack {
                Spacer().frame(height: 59)
                
                HStack{
                    Spacer().frame(width: 19)
                    
                    Text("우리의 경고 알림은\n“보조 수단”일 뿐입니다.")
                        .font(
                            Font.custom("Spoqa Han Sans Neo", size: 25)
                                .weight(.bold)
                        )
                        .foregroundColor(Color("HWhite"))
                    
                    Spacer()
                }
                
                Spacer().frame(height: 21)

                HStack{
                    Spacer().frame(width: 16)
                    
                    Text("이 앱은 위험 신호를 보조적으로 알리는 도구입니다. \n사용자의 안전 주의는 가장 중요한 요소입니다.\n항상 주변 상황을 확인해 주세요.")
                      .font(Font.custom("Spoqa Han Sans Neo", size: 14))
                      .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                      .frame(width: 345, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 103)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 195.89835, height: 195.89835)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 87)
                
                HStack(spacing: 4) {
                                ForEach(1..<4) { index in // 2, 3, 4 페이지 인디케이터
                                    Circle()
                                        .fill(currentPage == index ? Color.white : Color.gray) // 현재 페이지에 따라 색상 조정
                                        .frame(width: 8, height: 8)
                                }
                            }
                Spacer().frame(height: 51)
                
                Button(action: {
                    currentPage = 4
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 361, height: 58)
                            .background(Color.white)
                            .cornerRadius(10)
                            .opacity(0.28)
                        
                        Text("확인")
                            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .tag(3)
            
            // 다섯 번째 온보딩 페이지(마지막)
            VStack {
                Spacer().frame(height: 59)
                
                HStack{
                    Spacer().frame(width: 19)
                    
                    Text("정확한 위치 확인을 위해서\n거치대를 활용해주세요")
                        .font(
                            Font.custom("Spoqa Han Sans Neo", size: 25)
                                .weight(.bold)
                        )
                        .foregroundColor(Color("HWhite"))
                    
                    Spacer()
                }
                
                Spacer().frame(height: 21)

                HStack{
                    Spacer().frame(width: 16)
                    
                    Text("더 안전하고 정확한 경고 알림을 받기 위해\n스마트폰을 거치대에 고정해 주행해 주세요.")
                      .font(Font.custom("Spoqa Han Sans Neo", size: 14))
                      .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                      .frame(width: 345, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 139)
                
                Image(systemName: "iphone.gen1.radiowaves.left.and.right")
                    .resizable()
                    .frame(width: 135.84792, height: 180)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 162)
                
                Button(action: {
                    appRootManager.currentRoot = .home
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 361, height: 58)
                            .background(Color.white)
                            .cornerRadius(10)
                            .opacity(0.28)
                        
                        Text("확인")
                            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .tag(4)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
        
    }
    
}
