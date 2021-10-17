//
//  SoundManager.swift
//  MatchGame
//
//  Created by Michael Shustov on 17.10.2021.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            case .flip:
                soundFileName = "cardflip"
                
            case .match:
                soundFileName = "dingcorrect"
                
            case .nomatch:
                soundFileName = "dingwrong"
                
            case .shuffle:
                soundFileName = "shuffle"
        }
        
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play the sound
            audioPlayer?.play()
        }
        catch {
            print(error.localizedDescription)
            return
        }
        
        
    }
}
