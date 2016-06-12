//
//  RecorderHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import AVFoundation

class RecorderHelper: NSObject, AVAudioRecorderDelegate {
    
    let dateUtility = DateUtility()
    
    var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder?
    var recordItemId: String?
    var recordItemFilename: String?
    
    typealias StartRecordClosureType = (success: Bool) -> Void
    typealias StopRecordClosureType = (recordItemData: [String: AnyObject]) -> Void
    
    var startTimeEpoch: Int = 0
    var stopTimeEpoch: Int = 0
    
    override init() {
        super.init()
        self.initRecordingSession()
    }
    
    func initRecordingSession() {
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission({ (allowed) in
                dispatch_async(dispatch_get_main_queue(), { 
                    if allowed {
                        // load recording ui
                    } else {
                        
                    }
                })
            })
        } catch {
            print(error)
        }
    }
    
    func closeRecordingSession() {
        do {
            try recordingSession.setActive(false)
        } catch {
            print(error)
        }
    }
    
    func startRecording(recordStarted: StartRecordClosureType) {
        self.recordItemId = NSUUID().UUIDString
        let audioFilename = "\(getDocumentsDirectory())/\(self.recordItemId!)-recording.m4a"
        self.recordItemFilename = audioFilename
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder!.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder!.record()
            startTimeEpoch = self.dateUtility.convertDateToEpoch(NSDate())
            recordStarted(success: true)
        } catch {
            print(error)
            self.stopRecording(nil)
            recordStarted(success: false)
        }
    }
    
    func stopRecording(recordStopped: StopRecordClosureType?) {
        if audioRecorder != nil {
            audioRecorder!.stop()
            stopTimeEpoch = self.dateUtility.convertDateToEpoch(NSDate())
            let durationTI = NSTimeInterval(stopTimeEpoch - startTimeEpoch)
            let duration: String = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(durationTI)
            audioRecorder = nil
            if let recordStopped = recordStopped {
                let recordItemDict: [String: AnyObject] = [
                    "duration": duration,
                    "id": self.recordItemId!,
                    "filename": self.recordItemFilename!
                ]
                recordStopped(recordItemData: recordItemDict)
            }
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(nil)
        }
    }
    
}
