//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//
import SwiftUI
import AVFoundation // AVAudioSession을 사용하기 위해 추가
import Lottie

struct OnboardingView: View {
  @StateObject var viewModel: OnboardingViewModel
  @State private var currentTab = 0 // 현재 탭 인덱스를 관리하는 변수
  @State private var isPermissionRequested: Bool = false // 권한 요청 상태를 추적
  
  var body: some View {
    
    ZStack {
      Color(hex: "FCFFF5") // 배경색 설정
        .ignoresSafeArea()
        Spacer().frame(height: 20)
      VStack(spacing: 20) {
        
  // MARK: 페이지 인디케이터, Skip 버튼
          HStack {
              HStack(spacing: 6) {
                  ForEach(0..<3) { index in
                      if currentTab == index {
                          Rectangle()
                              .fill(Color.gray)
                              .frame(width: 20, height: 8)
                              .cornerRadius(4)
                      } else {
                          Circle()
                              .fill(Color.gray.opacity(0.4))
                              .frame(width: 8, height: 8)
                      }
                  }
              }
              .padding(.leading, 20)
              
              Spacer()
              if currentTab < 2 {
                  Button {
                      if currentTab < 2 {
                          currentTab = 2
                      }
                  } label: {
                      Text("건너뛰기")
                          .font(Font.custom("Pretendard", size: 16))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                  }
                  Spacer().frame(width:22)
              }
          }
          .frame(height: 30)
        .padding(.top, 20)
        .padding(.bottom, 60)
        
// MARK: 상단 타이틀 및 설명
        VStack(spacing: 0) {
          if currentTab == 0 {
            Text("정확한 소리 수집을 위해\n휴대폰을 거치해주세요.")
              .font(.semiBold)
              .multilineTextAlignment(.center)
            
          } else if currentTab == 1 {
            Text("워치를 함께 사용하여\n소리를 진동으로 느껴보세요.")
              .font(.semiBold)
              .multilineTextAlignment(.center)
            
          } else if currentTab == 2 {
            Text("히어로드는 여러분의\n안전한 주행을 보조합니다.")
              .font(.semiBold)
              .multilineTextAlignment(.center)
              .padding(.bottom, 9)
            
            Text("피해 또는 상해를 입을 수 있는 상황, 고위험이나\n긴급 상황 중에는 알람에만 의존해서는 안됩니다.")
              .font(.LiveActivitySub)
              .foregroundColor(.black)
              .multilineTextAlignment(.center)
          }
        }
          ZStack {
              // 콘텐츠 슬라이드(TabView)
              TabView(selection: $currentTab) {
                  VStack {
                      Spacer().frame(width:20)
                      LottieView(animationName: "phone", animationScale: 1, loopMode: .loop)
                          .frame(width: 200, height: 200)
                  }
                  .tag(0)
                  
                  VStack {
                      LottieView(animationName: "watch 1", animationScale: 1, loopMode: .loop)
                          .frame(width: 250, height: 250)
                          .scaleEffect(1.1)
                          .offset(y: 40)
                      
                  }
                  .tag(1)
                  
                  VStack {
//                      LottieView(animationName: "watch 1", animationScale: 1, loopMode: .loop)
//                          .frame(width: 250, height: 250)
//                          .scaleEffect(1.1)
//                          .offset(y: 40)
                      Image("safeinfo")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 350, height: 350)
                  }
                  .tag(2)
              } 
              .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 페이지 인디케이터 숨기기
          }
        
      
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 페이지 인디케이터 숨기기
        .frame(height: 300)
        
          Spacer()
        
        // MARK: 버튼
        Button(action: {
          if currentTab < 2 {
            // 다음 페이지로 이동
            withAnimation {
              currentTab += 1
            }
          } else {
            // main 페이지로 이동
            viewModel.moveToHome()
          }
        }) {
          Text(currentTab == 2 ? "시작하기" : "확인") // 버튼 텍스트
        }
        .buttonStyle(CustomButtonStyle())
        .padding(.bottom, 63)
        
      }
    }
  }
  
  private func requestMicrophonePermission() {
    if #available(iOS 17.0, *) {
      // iOS 17 이상: 새로운 메서드 사용
      AVAudioApplication.requestRecordPermission { granted in
        DispatchQueue.main.async {
          if granted {
            print("마이크 접근 권한이 허용되었습니다.")
          } else {
            print("마이크 접근 권한이 거부되었습니다.")
          }
        }
      }
    } else {
      // iOS 17 미만: 기존 메서드 사용
      AVAudioSession.sharedInstance().requestRecordPermission { granted in
        DispatchQueue.main.async {
          if granted {
            print("마이크 접근 권한이 허용되었습니다.")
          } else {
            print("마이크 접근 권한이 거부되었습니다.")
          }
        }
      }
    }
  }
}

#Preview {
  OnboardingView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
