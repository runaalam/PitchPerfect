//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Runa Alam on 10/8/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var recordView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    let playViewIdentifier = "stopRecording"
    var audioRecorder: AVAudioRecorder!
    var pulseEffect = LFTPulseAnimation()
    
    enum RecordStatus {
        case recording, notRecording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabelAndButton(.notRecording)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        configureLabelAndButton(.recording)
        startRecording()
        
        // Set Pulse Animation in the center of the view around stop button
        pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:150, position:self.recordView.center)
        recordView.layer.insertSublayer(self.pulseEffect, below: self.stopButton.layer)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        configureLabelAndButton(.notRecording)
        stopRecording()
        
        // Stop Pulse Animation
        self.pulseEffect.removeAllAnimations()
    }
    
    func configureLabelAndButton(_ recordStatus: RecordStatus){
        switch(recordStatus) {
        case .notRecording:
            recordLabel.text = "Tap to start recording"
            recordButton.isHidden = false
            stopButton.isHidden = true
        case .recording:
            recordLabel.text = "Tap to stop recording"
            recordButton.isHidden = true
            stopButton.isHidden = false
        }
    }

    // MARK: - Audio Recorder Delegate
    
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: playViewIdentifier, sender: audioRecorder.url)
        } else {
            print("Record is not successful")
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == playViewIdentifier {
            let playVC = segue.destination as! PlayViewController
            let recordedAudioURL = sender as! URL
            playVC.recordedAudioURL = recordedAudioURL
        }
    }
}
