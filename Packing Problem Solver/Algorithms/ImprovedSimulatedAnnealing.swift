//
//  ImprovedSimulatedAnnealing.swift
//  Packing Problem Solver
//
//  Created by Dinesh Harjani on 14/11/16.
//  Copyright © 2016 Dinesh Harjani. All rights reserved.
//

import Cocoa

class ImprovedSimulatedAnnealing: SimulatedAnnealing {

	private static let ThreeMovementTemperatureThreshold = 17.0
	private static let TwoMovementTemperatureThreshold = 6.0
	
	override internal func neighbor(startingSolution: [Int], currentTemperature: Double) -> [Int] {
		if (currentTemperature >= ImprovedSimulatedAnnealing.ThreeMovementTemperatureThreshold) {
			return Movement.ThreeExchange.performMovement(initialSolution: startingSolution)
		} else if (currentTemperature >= ImprovedSimulatedAnnealing.TwoMovementTemperatureThreshold) {
			return Movement.TwoExchange.performMovement(initialSolution: startingSolution)
		} else {
			return Movement.OneExchange.performMovement(initialSolution: startingSolution)
		}
	}
}