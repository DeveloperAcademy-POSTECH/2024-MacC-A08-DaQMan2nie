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
            Spacer().frame(height: 84)
            
            HStack {
                Spacer().frame(width: 16)
                
                Text("안전 주행 완료!")
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
                
                Text("오늘도 히어로드와 함께 무사히 도착하셨습니다.\n다음에도 안전하게 뵙겠습니다!")
                    .font(Font.custom("Spoqa Han Sans Neo", size: 16))
                    .foregroundColor(Color("HGray2"))
                    .frame(width: 295, alignment: .topLeading)
                
                Spacer()
            }
            
            Spacer().frame(height: 104)
            
            Image(systemName: "checkmark.circle.fill") // SF Symbols에서 원형 아이콘 사용
                .resizable()
                .frame(width: 160, height: 160)
                .foregroundColor(Color("HPrimaryColor")) // 아이콘 색상 설정
            
            Spacer().frame(height: 231)
            
            Button(action: {
                viewModel.goToHome() // 홈으로 돌아가는 동작
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
