//
//  Adjust1Controller.swift
//  study0925
//
//  Created by doi-macbook on 2022/09/26.
//

import UIKit
import AVFoundation
import Foundation

class Adjust1Controller: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = true
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    
    
    var xEndedTaplist: [Double] = []
    var yEndedTaplist: [Double] = []

    var tapxy:String = ""
    
    var xkiroku:[Double] = []
    var ykiroku:[Double] = []
        
    var synthesizer: AVSpeechSynthesizer!
    var voice: AVSpeechSynthesisVoice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true;
        
        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
        speak("補正点１を登録してください")
        
        let st = UITapGestureRecognizer(target: self, action: #selector(screenTransition(_:)))
        st.numberOfTouchesRequired = 2
        st.numberOfTouchesRequired = 2
        view.addGestureRecognizer(st)
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
                    tapxy = "エックス" + String(xEndedTaplist[i]) + "ワイ" + String(yEndedTaplist[i])
                    xkiroku.append(xEndedTaplist[i])
                    ykiroku.append(yEndedTaplist[i])
                    print(xkiroku)
                    print(ykiroku)
                    speak(tapxy)
                }
                
                break
            }
            
        }else{
            print("配列要素数1")
        }
        print("====")
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
                  
    @IBAction func screenTransition(_ gesture: UILongPressGestureRecognizer){
        print("doubletap_doubletouch")
        performSegue(withIdentifier: "toAdjust2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdjust2" {
            let nextview = segue.destination as! Adjust2Controller
            if let xkiroku:Double = xkiroku.last, let ykiroku:Double = ykiroku.last{
                nextview.xTap1 = xkiroku
                nextview.yTap1 = ykiroku
            }else{
                print("nil error")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
