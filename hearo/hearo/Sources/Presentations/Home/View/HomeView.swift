//
//  HomeView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var circleOffset: CGFloat = 0
    @State private var showHintAndAnimation: Bool = true // 로티와 힌트 텍스트 및 힌트 원 표시 여부
    @State private var startLottieAnimation: Bool = false // Lottie 애니메이션 시작 여부
    @State private var backgroundOpacity: Double = 0.0 // 흰 배경 불투명도
    @State private var isInfoActive: Bool = false // Info로 이동 여부를 관리하는 상태
    
    private let targetOffset: CGFloat = 274
    private let minimumOffset: CGFloat = 197
    private let transitionDelay: Double = 3.0 // 화면 전환 딜레이 시간 (초)
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white // 다크 모드에서도 흰 배경 유지
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 89)
                    
                    HStack(alignment: .top) {
                        Spacer().frame(width: 16)
                        
                        Text("오늘도 히어로드와 함께\n안전한 주행하세요!")
                            .font(.semiBold)
                            .foregroundColor(Color("MainFontColor"))
                            .lineSpacing(5)
                            .frame(height: 70)
                        
                        Spacer()
                        
                        VStack{
                            Spacer().frame(height: 5)
                            NavigationLink(destination: Info(isHomeActive: $isInfoActive), isActive: $isInfoActive) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "D4D4D4"))
                            }
                        }
                        Spacer().frame(width: 25)
                    }
                    
                    Spacer().frame(height: 60)
                    
                    if showHintAndAnimation{
                        
                        Text("아이콘을 아래로 내리면 주행이 시작됩니다.")
                            .font(.hint)
                            .foregroundColor(Color("SubFontColor"))
                            .offset(y: 60)
                            .allowsHitTesting(false) // 텍스트도 터치 이벤트를 방해하지 않도록 설정
                    }
                    
                    Spacer().frame(height: 60)
                    
                    ZStack {
                        // 목표 지점 힌트 원
                        if showHintAndAnimation {
                            Circle()
                                .fill(Color(hex: "58D53C").opacity(0.1))
                                .frame(width: 139, height: 139)
                                .position(x: UIScreen.main.bounds.width / 2, y: targetOffset + 80)
                                .allowsHitTesting(false) // 힌트 원의 터치 이벤트 차단
                        }
                        
                        // 원형 버튼 (항상 터치 우선순위가 높도록 ZStack의 마지막에 배치)
                        Image("StartCircle")
                            .offset(y: circleOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showHintAndAnimation = false
                                        }
                                        let newOffset = value.translation.height
                                        circleOffset = max(0, min(targetOffset, newOffset))
                                    }
                                    .onEnded { value in
                                        if circleOffset >= minimumOffset {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                circleOffset = targetOffset
                                            }
                                            triggerFinalHaptic()
                                            startLottieAnimation = true
                                            
                                            // 화면 전환 딜레이 추가
                                            DispatchQueue.main.asyncAfter(deadline: .now() + transitionDelay) {
                                                withAnimation(.easeIn(duration: 2.0)) {
                                                    backgroundOpacity = 1.0
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                    viewModel.startWorking()
                                                }
                                            }
                                        } else {
                                            withAnimation(.easeOut) {
                                                circleOffset = 0
                                                showHintAndAnimation = true
                                            }
                                        }
                                    }
                            )
                    }
                    
                    
                    Spacer().frame(height: 152)
                    
                    
                    if showHintAndAnimation {
                        LottieView(animationName: "arrow_GR", animationScale: 1)
                            .frame(height: 150, alignment: .top)
                            .scaleEffect(x: 1.1, y: 1.0)
                            .offset(y: -300)
                            .padding()
                            .allowsHitTesting(false) // 애니메이션이 터치 이벤트를 방해하지 않도록 설정
                        
                        
                        
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                
                // "start_view" Lottie 애니메이션
                if startLottieAnimation {
                    LottieView(animationName: "start_view", animationScale: 1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .offset(y: targetOffset-30)
                        .edgesIgnoringSafeArea(.all)
                }
                
                // 흰색 배경 오버레이
                Color.white
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(appRootManager: AppRootManager()))
}
