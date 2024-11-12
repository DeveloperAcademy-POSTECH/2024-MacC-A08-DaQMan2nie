//
//  FinishView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct FinishView: View {
    @ObservedObject var viewModel: FinishViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 195)
            
         
                Text("안전 주행 완료!")
                    .font(
                        Font.custom("Spoqa Han Sans Neo", size: 24)
                            .weight(.bold)
                    )
                    .foregroundColor(Color.black)
                
            
            Spacer().frame(height: 10)
    
            Text("오늘도 함께 무사히 도착했습니다.\n다음에도 안전하게 뵙겠습니다.")
                .font(Font.custom("Spoqa Han Sans Neo", size: 15))
                .foregroundColor(Color("MainFontColor"))
                .font(Font.custom("Pretendard", size: 15))
                .foregroundColor(Color(red: 0.24, green: 0.26, blue: 0.31))
                .frame(width: 345, alignment: .center) // 가로 중앙 정렬
                .multilineTextAlignment(.center)       // 텍스트 줄바꿈 시 가운데 정렬
                
               
          
            
            Spacer().frame(height: 72)
            
            Image(systemName: "checkmark.circle.fill") // SF Symbols에서 원형 아이콘 사용
                .resizable()
                .frame(width: 121, height: 121)
                .foregroundColor(Color("HPrimaryColor")) // 아이콘 색상 설정
            
            Spacer().frame(height: 231)
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 1, green: 1, blue: 1, opacity: 1))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.stopRecording()
        }
    }
}
