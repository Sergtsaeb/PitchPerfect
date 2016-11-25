//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Sergelenbaatar Tsogtbaatar on 11/10/16.
//  Copyright © 2016 Sergts. All rights reserved.
//


    import UIKit
    import AVFoundation
    
    class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
        
        
        @IBOutlet weak var stopRecordingButton: UIButton!
        @IBOutlet weak var recordingLabel: UILabel!
        @IBOutlet weak var recordButton: UIButton!
        
        var audioRecorder: AVAudioRecorder!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            stopRecordingButton.isEnabled = false
            
            recordButton.imageView?.contentMode = .scaleAspectFit
            stopRecordingButton.imageView?.contentMode = .scaleAspectFit
            
        }
        
        func setUIState(recordState isRecording:Bool, textValue recordingText:String)
        {
            
            recordingLabel.text? = recordingText
            
            if isRecording == true {
                recordButton.isEnabled = false
                stopRecordingButton.isEnabled = true
            } else {
                stopRecordingButton.isEnabled = true
                recordButton.isEnabled = false
            }
        }
        
        @IBAction func recordAudio(_ sender: Any) {
            
            
            setUIState(recordState: false, textValue: "Recording in progress")
            
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURL(withPathComponents: pathArray)
            print(filePath!)
            
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        
        
        @IBAction func stopRecording(_ sender: Any) {
            
            setUIState(recordState: true , textValue: "Tap to record")
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            print("viewWillAppear called")
        }
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            print("AVAudioRecorder finished saving recording")
            if (flag) {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            } else {
                print("Saving of recording failed")
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "stopRecording" {
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! URL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
        }
        
        
    }
    
