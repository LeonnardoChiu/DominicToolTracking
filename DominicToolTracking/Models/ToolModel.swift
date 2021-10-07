//
//  ToolModel.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import Foundation

struct Tool {
    let name: String
    let count: Int
    var totalLoaned: Int = 0
}

func getDefaultTools() -> [Tool]  {
    return [Tool(name: "Wrench", count: 6),
            Tool(name: "Cutter", count: 15),
            Tool(name: "Pliers", count: 15),
            Tool(name: "Screwdriver", count: 13),
            Tool(name: "Welding Machine", count: 3),
            Tool(name: "Welding Glasses", count: 7),
            Tool(name: "Hammer", count: 4),
            Tool(name: "Measuring Tape", count: 9),
            Tool(name: "Alan Key Set", count: 4),
            Tool(name: "Air Compressor", count: 2),]
}
