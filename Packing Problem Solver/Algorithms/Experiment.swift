//
//  Experiment.swift
//  Packing Problem Solver
//
//  Created by Dinesh Harjani on 26/10/16.
//  Copyright © 2016 Dinesh Harjani. All rights reserved.
//

import Cocoa

class Experiment: NSObject {

	private let TimerInterval = 1
	
	var bestSolution: BaseStrip?
	
	private var callbackQueue: DispatchQueue {
		return DispatchQueue.main
	}
	private var controlQueue: DispatchQueue {
		return DispatchQueue(label: "com.packagesolver.experiment.control")
	}
	private var computationalQueue: DispatchQueue {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
	}
	
	private let problem: Problem
	private let algorithm: HeuristicAlgorithm
	private let timeLimit: Int
	private let numberOfThreads: Int
	
	private var timer: Timer
	private var accumulatedTime: Int
	private var finished: Bool
	private var callback: ((_ elapsed: Int, _ finished: Bool) -> Void)?
	
	init (problem: Problem, algorithm: HeuristicAlgorithm, timeLimit: Int, numberOfThreads: Int) {
		self.problem = problem
		self.algorithm = algorithm
		self.timeLimit = timeLimit
		self.numberOfThreads = numberOfThreads
		self.timer = Timer()
		accumulatedTime = 0
		finished = false
	}
	
	func run(callback: @escaping (_ elapsed: Int, _ finished: Bool) -> Void) {
		self.callback = callback
		self.timer.invalidate()
		finished = false
		
		/*
		do {
			try self.bestSolution = problem.applySolution(solution: Random().solve(problem: problem))
		} catch {
			
		}
		*/
		
		accumulatedTime = 0
		timer = Timer.scheduledTimer(timeInterval: TimeInterval(TimerInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
		for _ in 1...numberOfThreads {
			computationalQueue.async(execute: solve)
		}
	}
	
	func timerAction() {
		controlQueue.async { 
			self.accumulatedTime += self.TimerInterval
			if (self.accumulatedTime >= self.timeLimit) {
				self.timer.invalidate()
				self.finished = true
			}
			
			self.callbackQueue.async {
				self.callback!(self.accumulatedTime, self.finished)
			}
		}
	}
	
	private func solve() {
		var numberOfIterations = 0
		while (!finished) {
			do {
				let solutionOrder = algorithm.solve(problem: problem)
				let solution = try problem.applySolution(solution: solutionOrder)
				
				guard (!finished) else {
					return
				}
				
				controlQueue.sync {
					guard (bestSolution != nil) else {
						bestSolution = solution
						return;
					}
					
					if (bestSolution!.height >= solution.height
						|| bestSolution!.totalEmptySpacesArea() > solution.totalEmptySpacesArea()) {
						bestSolution = solution
					}
				}
			} catch {
				// try again
			}
			
			numberOfIterations += 1
			print(numberOfIterations)
		}
	}
}
