//
//  SimulatedAnnealing.swift
//  Packing Problem Solver
//
//  Created by Dinesh Harjani on 9/11/16.
//  Copyright © 2016 Dinesh Harjani. All rights reserved.
//

import Cocoa

class SimulatedAnnealing: HeuristicAlgorithm {
	
	private static let MaxNumberOfSteps = 10
	
	override func solve(problem: Problem) -> [Int] {
		var bestSolution: [Int]
		
		do {
			bestSolution = Algorithms.RandomAlgorithm.instance().solve(problem: problem)
			var bestStrip = try problem.applySolution(solution: bestSolution)
			var currentSolution = bestSolution
			var currentStrip = bestStrip
			
			var temperature = startingTemperature()
			var numberOfSteps = 1
			
			repeat {
				for _ in 1...numberOfSteps {
					let neighborSolution = neighbor(startingSolution: currentSolution, currentTemperature: temperature)
					let neighborStrip = try problem.applySolution(solution: neighborSolution)
					
					if (neighborStrip.isBetterThan(otherStrip: bestStrip)) {
						bestSolution = neighborSolution
						bestStrip = neighborStrip
					}
					
					if (neighborStrip.isBetterThan(otherStrip: currentStrip)
						|| acceptWorseSolution(currentValue: currentStrip.guidanceValue(), proposedValue: neighborStrip.guidanceValue(), temperature: temperature)) {
						currentSolution = neighborSolution
						currentStrip = neighborStrip
					}
				}
				
				temperature = cooldown(temperature: temperature)
				if (numberOfSteps < SimulatedAnnealing.MaxNumberOfSteps) {
					numberOfSteps += 1
				}
			} while (temperature > haltingTemperature())
		}
		catch {
			// Keep going.
		}
		
		return bestSolution
	}
	
	internal func startingTemperature() -> Double {
		return 29.87
	}
	
	internal func haltingTemperature() -> Double {
		return 1.0
	}
	
	internal func cooldown(temperature: Double) -> Double {
		return temperature * 0.877
	}
	
	internal func neighbor(startingSolution: [Int], currentTemperature: Double) -> [Int] {
		return Movement.OneExchange.performMovement(initialSolution: startingSolution)
	}
	
	private func acceptWorseSolution(currentValue: Int, proposedValue: Int, temperature: Double) -> Bool {
		let p = abs(Double(currentValue) - Double(proposedValue)) / temperature
		let r = randomNumberBetweenZeroAndOne()
		return exp(p) > r
	}
	
	private func randomNumberBetweenZeroAndOne() -> Double {
		return Double(arc4random()) / Double(UInt32.max)
	}
}
