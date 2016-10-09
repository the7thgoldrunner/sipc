//
//  BottomLeft.swift
//  Packing Problem Solver
//
//  Created by Dinesh Harjani on 9/10/16.
//  Copyright © 2016 Dinesh Harjani. All rights reserved.
//

import Cocoa

class BottomLeft: PlacementAlgorithm {

	let INF = Int.max
	
	func placeRectangles(rectangles: [Rectangle], order: [Int], strip: Strip) {
		var y = 0
		var rectanglesToPlace = rectangles
		
		// One while iteration per shelf.
		while (!rectanglesToPlace.isEmpty) {
			var x = 0
			var availableWidth = strip.width
			var shelfHeight = INF
			var i = 0
			
			while (i < rectanglesToPlace.count) {
				let rectangle = rectanglesToPlace[i]
				
				if (rectangle.fitsIn(width: availableWidth, height: shelfHeight)) {
					strip.placeRectangle(rectangle: rectangle, position: Position(x: x, y: y))
					rectanglesToPlace.remove(at: i)
					
					x += rectangle.width
					availableWidth -= rectangle.width
					if (shelfHeight == INF) {
						shelfHeight = rectangle.height
					}
				} else {
					i += 1
				}
			}
			
			// Move to next shelf.
			y += shelfHeight
		}
	}
}