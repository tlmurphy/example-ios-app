//
//  MemeTrackerTests.swift
//  MemeTrackerTests
//
//  Created by Trevor Murphy on 8/8/17.
//  Copyright © 2017 Trevor Murphy. All rights reserved.
//

import XCTest
@testable import MemeTracker

class MemeTrackerTests: XCTestCase {
    
    // MARK: Meme Class Tests
    // Confirm that the Meme initializer returns a Meme object when passed valid parameters.
    func testMemeInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeme = Meme.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeme)
        
        // Highest positive rating
        let positiveRatingMeme = Meme.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeme)
    }
    
    // Confirm that the Meme initializer returns nil when passed a negative rating or an empty name.
    func testMemeInitializationFails() {
        // Negative rating
        let negativeRatingMeme = Meme.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeme)
        
        // Rating exceeds maximum
        let largeRatingMeme = Meme.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeme)
        
        // Empty String
        let emptyStringMeme = Meme.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeme)
    }
}
