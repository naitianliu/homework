//
//  PlayerHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerHelper: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
    }
    
    func startPlay(filenamePath: String) {
        let playSoundURL = NSURL(fileURLWithPath: filenamePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: playSoundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    func pausePlay() -> NSTimeInterval? {
        audioPlayer?.pause()
        return audioPlayer?.currentTime
        
    }
    
    func stopPlay() -> NSTimeInterval? {
        audioPlayer?.stop()
        return audioPlayer?.currentTime
    }
    
    func getCurrentTime() -> NSTimeInterval {
        var currentTime: NSTimeInterval = 0
        if let player = audioPlayer {
            currentTime = player.currentTime
        }
        return currentTime
    }
}