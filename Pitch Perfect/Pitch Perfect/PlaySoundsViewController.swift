//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by dj fant on 4/1/15.
//  Copyright (c) 2015 djfant. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //globals
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    //system event functions
    override func viewDidLoad() {
        //runs at load
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //user defined actions
    @IBAction func playFast(sender: UIButton) {
        playAudioAtDifferentRate(2.0)
    }

    @IBAction func playSlow(sender: UIButton) {
        playAudioAtDifferentRate(0.5)
    }
    @IBAction func playStop(sender: UIButton) {
        playReset()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    //user defined functions
    func playReset(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    func playAudioAtDifferentRate(speed:Float){
        playReset()
        audioPlayer.enableRate = true
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    func playAudioWithVariablePitch(pitch: Float){
        playReset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
}
