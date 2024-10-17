//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            // 첫 번째 온보딩 페이지
            VStack {
                Spacer().frame(height: 59)
                
                HStack {
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
                
                HStack {
                    Spacer().frame(width: 16)
                    
                    Text("히여로는 주행 중 위험 신호를 실시간으로 감지해\n시각과 진동으로 알려드립니다.")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                        .foregroundColor(Color("HGray2"))
                        .frame(width: 295, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 102)
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 189, height: 189)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 120)
                
                Button(action: {
                    viewModel.moveToNextPage() // 두 번째 페이지로 전환
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
                
                HStack {
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
                
                HStack {
                    Spacer().frame(width: 16)
                    
                    Text("안전한 주행을 위해, 주행 중 경적, 사이렌 소리 등\n중요한 경고 신호를 놓치지 않도록 알림을 허용해 주세요.")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                        .foregroundColor(Color("HGray2"))
                        .frame(width: 295, alignment: .topLeading)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 139)
                
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 138.34, height: 161.72)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 121.28)
                
                Button(action: {
                    viewModel.moveToNextPage() // 세 번째 페이지로 전환
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
            
            // 추가 페이지들도 동일한 방식으로 추가...
            
            // 마지막 온보딩 페이지
            VStack {
                Spacer().frame(height: 59)
                
                HStack {
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
                
                HStack {
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
                    .frame(width: 135.84, height: 180)
                    .foregroundColor(Color("HPrimaryColor"))
                
                Spacer().frame(height: 162)
                
                Button(action: {
                    viewModel.moveToHome() // 홈 화면으로 전환
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
