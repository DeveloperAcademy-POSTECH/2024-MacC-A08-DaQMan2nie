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
    @State private var showTip: Bool = true // 주행 팁 텍스트 표시 여부
    @State private var showArrowAndText: Bool = false // 새로운 텍스트 및 애니메이션 표시 여부
    @State private var startLottieAnimation: Bool = false // Lottie 애니메이션 시작 여부
    @State private var backgroundOpacity: Double = 0.0 // 흰 배경 불투명도
    @State private var isInfoActive: Bool = false // Info로 이동 여부를 관리하는 상태
    
    
    private var randomTip: String {
        let tips = TipMessage.allCases
        return tips.randomElement()?.message ?? ""
    }
    
    private let targetOffset: CGFloat = 274
    private let minimumOffset: CGFloat = 197
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 89)
                    
                    HStack {
                        Spacer().frame(width: 16)
                        
                        Text("오늘도 히어로드와 함께\n안전한 주행 함께해요!")
                            .font(.mainTitle)
                            .foregroundColor(Color("MainFontColor"))
                            .frame(height: 70)
                        
                        Spacer()
                        
                        NavigationLink(destination: Info(isHomeActive: $isInfoActive), isActive: $isInfoActive) {
                                                  Image(systemName: "questionmark.circle.fill")
                                                      .resizable()
                                                      .scaledToFit()
                                                      .frame(width: 30, height: 30)
                                                      .foregroundColor(.gray)
                                              }
                        
                        
                        Spacer().frame(width: 25)
                        
                    }
                    
                    Spacer().frame(height: 149)
                    
                    // 원형 버튼 드래그
                    Image("StartCircle")
                        .offset(y: circleOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        showTip = false
                                        showArrowAndText = false
                                    }
                                    let newOffset = value.translation.height
                                    circleOffset = max(0, min(targetOffset, newOffset))
                                }
                                .onEnded { value in
                                    if circleOffset >= minimumOffset {
                                        triggerFinalHaptic()
                                        startLottieAnimation = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            backgroundOpacity = 1.0
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                viewModel.startWorking()
                                            }
                                        }
                                    } else {
                                        circleOffset = 0
                                        showTip = true
                                    }
                                }
                        )
                    
                    Spacer().frame(height: 52)
                    
                    if showTip {
                        VStack {
                            Text("주행 Tip!")
                                .font(.medium)
                                .foregroundColor(Color("SubFontColor"))
                            
                            Text(randomTip)
                                .font(.light)
                                .foregroundColor(Color("SubFontColor"))
                                .multilineTextAlignment(.center)
                                .frame(height: 50)
                                .padding(.horizontal, 20)
                        }
                        .opacity(showTip ? 1 : 0)
                    }
                    
                    Spacer()
                }
                
                if startLottieAnimation {
                    LottieView(animationName: "start_view", animationScale: 1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .offset(y: 274)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}


//랜덤문구 정의
enum TipMessage: String, CaseIterable {
    case carefulObservation = "주변을 주의 깊게 살피며\n여유로운 주행을 즐겨보세요."
    case speedControl = "속도를 조절하며 주변 상황에 유의하세요.\n안전이 최우선입니다!"
    case warningCheck = "경고 알림이 울리면 한 번 뒤를 확인해 보세요.\n항상 안전이 우선이에요."
    case safeRoads = "안전한 주행을 위해 자전거 도로를 이용하고,\n교차로에서는 주의하세요."
    case stayCalm = "급한 상황에서도 여유를 잃지 마세요.\n제가 함께하고 있어요."
    case slipperyRoads = "주행 중 미끄러운 도로나 장애물에 유의하며\n편안히 주행하세요."
    case checkSurroundings = "주변 소리가 감지되면 잠시 속도를 줄이며\n상황을 확인해 보세요."
    
    var message: String {
        return self.rawValue
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(appRootManager: AppRootManager()))
}
