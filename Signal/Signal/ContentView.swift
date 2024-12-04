//
//  ContentView.swift
//  AudioPlayerApp
//
//  Created by Pil_Gaaang on 12/4/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var activeAudio: String? // 현재 활성화된 오디오 이름
    @State private var volume: Float = 1.0 // 음량 슬라이더 초기 값
    private var audioPlayers: [String: AVAudioPlayer] = {
        // AVAudioPlayer 초기화 코드
        let sounds = ["car", "siren", "bicycle"]
        var players = [String: AVAudioPlayer]()
        for sound in sounds {
            if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
                let url = URL(fileURLWithPath: path)
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    players[sound] = player
                    player.numberOfLoops = -1
                } catch {
                    print("Error loading sound: \(sound), \(error)")
                }
            }
        }
        return players
    }()

    var body: some View {
        ZStack {
            // 배경 색상 전체 화면에 적용
            Color("Radish")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 제목
                Text("Hearoad Tester")
                    .font(.system(size: 80, weight: .bold)) // 큰 크기와 볼드 텍스트
                    .foregroundColor(.black)
                    .padding(.bottom, 80)
                
                // 버튼 행
                HStack(spacing: 100) { // 버튼 간격 설정
                    // Car 버튼
                    Button(action: {
                        toggleAudio(named: "car")
                    }) {
                        Text("Play Car")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 300, height: 200) // 버튼 크기 설정
                            .background(activeAudio == "car" ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Siren 버튼
                    Button(action: {
                        toggleAudio(named: "siren")
                    }) {
                        Text("Play Siren")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 300, height: 200) // 버튼 크기 설정
                            .background(activeAudio == "siren" ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Bicycle 버튼
                    Button(action: {
                        toggleAudio(named: "bicycle")
                    }) {
                        Text("Play Bicycle")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 300, height: 200) // 버튼 크기 설정
                            .background(activeAudio == "bicycle" ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // 음량 조절 슬라이더
                VStack {
                    Text("Volume")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Slider(value: $volume, in: 0...1, step: 0.1)
                        .padding(.horizontal, 40)
                        .onChange(of: volume) { newVolume in
                            adjustVolume(to: newVolume)
                        }
                }
                .padding(.top, 50)
            }
        }
    }

    private func toggleAudio(named name: String) {
        // 모든 플레이어를 중지
        audioPlayers.forEach { _, player in
            player.stop()
        }

        if activeAudio == name {
            // 현재 활성화된 오디오 중지
            activeAudio = nil
        } else {
            // 선택된 오디오 재생
            activeAudio = name
            if let player = audioPlayers[name] {
                player.currentTime = 0 // 처음부터 재생
                player.play()
            }
        }
    }

    private func adjustVolume(to newVolume: Float) {
        // 선택된 오디오의 음량을 조정
        if let activeAudio = activeAudio, let player = audioPlayers[activeAudio] {
            player.volume = newVolume
        }
    }
}

#Preview {
    ContentView()
}
