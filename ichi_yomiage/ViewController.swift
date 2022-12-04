//
//  ViewController.swift
//  study0925
//
//  Created by doi-macbook on 2022/09/25.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = true
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    ///
    var xTap1:Double = 0.0
    var yTap1:Double = 0.0
    var xTap2:Double = 0.0
    var yTap2:Double = 0.0
    
    var xEndedTaplist: [Double] = []
    var yEndedTaplist: [Double] = []
    
    var Detail: [[String]] = [[]]
    var Count:[Int] = []
    var field:Int = 0
    
    var xratio:Double = 0.0
    var yratio:Double = 0.0
    
    var tapxy:String = ""
    
    var xkiroku:[Double] = []
    var ykiroku:[Double] = []

    var strTapPoint:String = ""
    var kyori:Double = 0.0

    var synthesizer: AVSpeechSynthesizer!
    var voice: AVSpeechSynthesisVoice!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true;
        print(xTap1,yTap1,xTap2,yTap2)
        
        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
        speak("学習を開始できます")
        /// ①DocumentsフォルダURL取得
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("フォルダURL取得エラー")
        }
        /// ②対象のファイルURL取得
        let fileURL = dirURL.appendingPathComponent("name1.csv")
         
        /// ③ファイルの読み込み
        guard let fileContents = try? String(contentsOf: fileURL) else {
        fatalError("ファイル読み込みエラー")
        }
        /// 読み込んだファイルを１行ずつ格納
        /// この時/r/n1が入ってしまう
        let csvLines = fileContents.components(separatedBy: .newlines)
        ///元々配列に入っているインデックス0を削除
        Detail.remove(at: 0)
        
        for csvData in csvLines {
            if csvData.isEmpty {
                continue
            }
            else{
                let csvDetail = csvData.components(separatedBy: ",")
                Detail.append(csvDetail)
            }
        }
        
        xratio = (Double(xTap2) - Double(xTap1)) / (Double(Detail[3][1])! - Double(Detail[2][1])!)
        yratio = (Double(yTap2) - Double(yTap1)) / (Double(Detail[3][2])! - Double(Detail[2][2])!)
        
        for _ in 8...(Detail.count-1){
            Count.append(0)
        }
        field = Detail[7].count - 6

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("離れた")
        for touch in touches {
            let location = touch.location(in: self.view)
            xEndedTaplist.append(location.x)
            yEndedTaplist.append(location.y)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.xEndedTaplist.removeFirst()
                self.yEndedTaplist.removeFirst()
            }
        }

        
        if xEndedTaplist.count >= 2{
            print("配列要素数",xEndedTaplist.count)
            for i in 0...xEndedTaplist.count-2{
                let d = sqrt(pow((xEndedTaplist[i]-(xEndedTaplist.last)!),2)+pow((yEndedTaplist[i]-(yEndedTaplist.last)!),2))
                //print(d)
                if d <= 10.39{
                    print("double tap:",d)
                    let ichi = coordinate_comp(x: Double(xEndedTaplist[i]),y: Double(yEndedTaplist[i]))
                    speak(ichi)
                    break
                }
            }
            
        }else{
            print("配列要素数1")
        }
        print("====")
    }
    
    func coordinate_comp(x:Double, y:Double) -> String {
        for i in 8...(Detail.count-1){
            let range = (Double(Detail[i][5]))! * (xratio+yratio)/2
            let xdist:Double = xTap1 + (Double(Detail[i][2])! - Double(Detail[2][1])!) * xratio
            let ydist:Double = yTap1 + (Double(Detail[i][3])! - Double(Detail[2][2])!) * yratio
            kyori = sqrt(pow((xdist-x),2) + pow((ydist-y),2))
            print(i-7,"番目",kyori )
            if range > sqrt(pow((xdist-x), 2) + pow((ydist-y), 2)){
                strTapPoint = Detail[i][6+Count[i-8]]
                if field != 1{
                    if Count[i-8] == 0 {
                        Count = Count.map{$0 * 0}
                        Count[i-8] += 1
                    }else if Count[i-8] >= field-1{
                        Count[i-8] = 0
                    }else{
                        Count[i-8] += 1
                    }
                }
                print(Count)
                ///print(range)
                break
            }
            else{
                strTapPoint = "登録点は見つかりませんでした"
            }
        }
        return strTapPoint
    }
    
    func speak(_ text: String) {
        if(synthesizer.isSpeaking){
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance.init(string: text)
        utterance.rate = 0.6
        utterance.voice = voice
        synthesizer.speak(utterance)
    }

        

}

