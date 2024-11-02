//
//  Metronome.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 12/10/2020.
//

import Foundation

class Metronome {
//    var tempo: Int
//    var beat: Int
//
//    init(tempo: Int, beat: Int) {
//        self.tempo = tempo
//        self.beat = beat
//    }
    
    func getTempo(rawValue: Float) -> Float {
        let inverse = 1/rawValue
        let tempoMarking = 60 / inverse
        return tempoMarking
    }
    
}

