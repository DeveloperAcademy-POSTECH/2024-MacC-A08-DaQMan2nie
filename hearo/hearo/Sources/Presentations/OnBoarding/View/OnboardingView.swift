//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
  @StateObject var viewModel: OnboardingViewModel
  @State private var currentPage: OnboardingPage = .warning
  
  var body: some View {
    
    ZStack {
      
      // 텍스트 영역 : currentPage 따라 다름
      VStack(alignment: .leading, spacing: 0) {
        Spacer().frame(height: 45)
        
        HStack(spacing: 0) {
          Spacer().frame(width: 16)
          
          VStack(alignment: .leading, spacing: 0) {
            Text(currentPage.title)
              .font(.mainTitle)
              .foregroundStyle(Color("MainFontColor"))
            
            Spacer().frame(height: 17)
            
            Text(currentPage.description)
              .font(.regular)
              .foregroundStyle(Color("SubFontColor"))
          }
          
          Spacer()
        }
        Spacer()
      }
      
      
      VStack(spacing: 7) {
        // Lottie 애니메이션 영역 - TabView로 슬라이드 가능
        TabView(selection: $currentPage) {
          Image(systemName: "exclamationmark.triangle.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.yellow)
            .tag(OnboardingPage.warning)
          
          Image(systemName: "bell.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.green)
            .tag(OnboardingPage.notification)
          
          Image(systemName: "lock.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.green)
            .tag(OnboardingPage.privacy)
          
          Image(systemName: "iphone.homebutton")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.green)
            .tag(OnboardingPage.stand)
          
          Image(systemName: "applewatch")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.green)
            .tag(OnboardingPage.watch)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(maxHeight: 374)
        .padding(.vertical, 20)
        
        // 커스텀 페이지 인디케이터
        HStack(spacing: 8) {
          ForEach(OnboardingPage.allCases, id: \.self) { page in
            Circle()
              .fill(currentPage == page ? Color(red: 113/255, green: 113/255, blue: 113/255) : Color(red: 36/255, green: 36/255, blue: 36/255).opacity(0.3))
              .frame(width: 8, height: 8)
          }
        }
        .padding(.bottom, 16)
      }
      
      if currentPage == .watch {
        VStack {
          Spacer()
          
          Button(action: {
            viewModel.moveToHome()
          }) {
            ZStack {
              Rectangle()
                .frame(width: 361, height: 58)
                .foregroundStyle(Color("HPrimaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
              
              Image("시작하기")
            }
          }
          
          Spacer().frame(height: 63)
        }
      }
    }
  }
  
  
  enum OnboardingPage: Int, CaseIterable {
    case warning
    case notification
    case privacy
    case stand
    case watch
    
    var title: String {
      switch self {
      case .warning:
        return "우리의 경고 알림은\n\"보조 수단\"이에요."
      case .notification:
        return "경적 소리 감지 시\n안전을 위해 알림을 허용해 주세요."
      case .privacy:
        return "저희는 오직 주행을 위한\n오디오를 써요."
      case .stand:
        return "정확한 감지를 위해\n주행 중 거치대를 사용해 주세요."
      case .watch:
        return "더 안전한 주행을 위해\n워치 앱을 함께 켜 주세요."
      }
    }
    
    var description: String {
      switch self {
      case .warning:
        return "저는 당신의 곁에서 위험을 감지해 드리지만, 무엇보다\n중요한 건 자신의 안전이에요. 함께 신중히 주행해요."
      case .notification:
        return "안전한 주행을 위해, 주행 중 경적 사이렌 소리 등\n중요한 경고 신호를 놓치지 않도록 알림을 허용해 주세요."
      case .privacy:
        return "• 마이크로 인식된 소리는 오직 위험 신호를 감지하기 위한\n목적으로만 사용됩니다.\n• 인식되는 소리는 실시간 분석 후 저장하지 않습니다."
      case .stand:
        return "안전한 주행을 위한 작은 준비가 큰 차이를 만듭니다."
      case .watch:
        return "워치가 있다면 워치 앱을 함께 켜 주세요.\n손목에서 바로 알림을 확인할 수 있습니다."
      }
    }
    
  }
}
  
  
  

#Preview {
  OnboardingView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
