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
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        @IBAction func recordAudio(_ sender: Any) {
            
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            
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
        
        
            print("Stop recording button pressed")
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
            
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
                self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
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
    
    
    


