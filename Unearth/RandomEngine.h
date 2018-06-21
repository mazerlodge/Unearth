//
//  RandomEngine.h
//  RandomUtility
//
//  Created by mazerlodge on 10/4/09.
//  Copyright 2018 mazerlodge. All rights reserved.
//
#import <Cocoa/Cocoa.h>


@interface RandomEngine : NSObject {
	
	int currentSeed;
	int currentRaw;
	int currentRandValue;

}

- (int) getTimeBasedSeed;

- (void) setSeed: (int) seedValue;

- (int) getSeed;

- (int) getCurrentRaw;

- (int) getCurrentRandValue;

- (int) getNextRand: (int) numberOfDigits;

- (int) getNextRandInRange: (NSRange) theRange;

- (int) getNextRandBetween: (int) minValueInclusive maxValueInclusive: (int) maxValue;


@end
