//
//  Domain.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import Foundation

/// The domain a user can pick
enum Domain: CaseIterable {
    
    case none
    case actor
    case animation
    case artDirector
    case cinematographer
    case director
    case editor
    case filmGear
    case filmCritic
    case musicDirector
    case producer
    case productionHouse
    case screenWriter
    case soundDesigner
    case vfxArtist
    case writer
    
    var title: String {
        switch self {
        case .none: return ""
        case .actor: return "Actor"
        case .animation: return "Animation"
        case .artDirector: return "Art Director"
        case .cinematographer: return "Cinematographer"
        case .director: return "Director"
        case .editor: return "Editor"
        case .filmGear: return "Film Gear"
        case .filmCritic: return "Film Critic"
        case .musicDirector: return "Music Director"
        case .producer: return "Producer"
        case .productionHouse: return "Production House"
        case .screenWriter: return "Screen Writer"
        case .soundDesigner: return "Sound Designer"
        case .vfxArtist: return "VFX Artist"
        case .writer: return "Writer"
        }
    }
    
    static func getDomainFromString(string: String) -> Domain {
        for domain in Domain.allCases {
            if string == domain.title {
                return domain
            }
        }
        
        print("Invalid String")
        return .none
    }
}

struct Domains {
    
    var domains: [String] = ["Actor", "Animation", "Art Director", "Cinematographer", "Director", "Editor", "Film Gear", "Film Critic", "Music Director", "Producer", "Production House", "Screen Writer", "Sound Designer", "VFX Artist", "Writer"]
}
