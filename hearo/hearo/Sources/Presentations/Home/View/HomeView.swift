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

    var body: some View {
        NavigationView {
            ZStack {
                Color.white // 다크 모드에서도 흰 배경 유지
                    .ignoresSafeArea()

                VStack {
                    Spacer().frame(height: 89)

                    HStack(alignment: .top) {
                        Spacer().frame(width: 16)
                        
                        Text("오늘도 히어로드와 함께\n안전한 주행 함께해요!")
                            .font(.mainTitle)
                            .foregroundColor(Color("MainFontColor"))
                            .lineSpacing(5)
                            .frame(height: 70)

                        Spacer()
                        

                        NavigationLink(destination: Info(isHomeActive: $isInfoActive), isActive: $isInfoActive) {
                            Image(systemName: "exclamationmark.circle.fill")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 45, height: 45)
                        }

                        Spacer().frame(width: 25)
                    }
                    
                    Spacer().frame(height: 60)
                    
                    if showHintAndAnimation{
                        
                        Text("아이콘을 아래로 내리면 주행이 시작됩니다.")
                            .font(.light)
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
                                .position(x: UIScreen.main.bounds.width / 2, y: targetOffset + 100)
                                .allowsHitTesting(false) // 힌트 원의 터치 이벤트 차단
                        }
                        
                        // 원형 버튼 (항상 터치 우선순위가 높도록 ZStack의 마지막에 배치)
                        Image("StartCircle")
                            .offset(y: circleOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // 드래그 중 힌트와 애니메이션을 숨김
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showHintAndAnimation = false
                                        }
                                        let newOffset = value.translation.height
                                        // offset을 제한하여 부드럽게 드래그 가능하도록 설정
                                        circleOffset = max(0, min(targetOffset, newOffset))
                                    }
                                    .onEnded { value in
                                        if circleOffset >= minimumOffset {
                                            // 목표 지점으로 부드럽게 이동
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                circleOffset = targetOffset
                                            }
                                            triggerFinalHaptic() // 진동 효과 실행
                                            startLottieAnimation = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                withAnimation(.easeIn(duration: 2.0)) {
                                                    backgroundOpacity = 1.0
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                    viewModel.startWorking()
                                                }
                                            }
                                        } else {
                                            // 드래그 실패 시 원래 위치로 부드럽게 복귀
                                            withAnimation(.easeOut){
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
                        .offset(y: 220)
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
