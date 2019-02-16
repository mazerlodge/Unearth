//
//  StoneBag.m
//  Unearth
//
//  Created by Mazerlodge on 1/26/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import "StoneBag.h"

@implementation StoneBag

- (id) initWithStoneBag: (NSArray *) startBag {
	nextStoneIndex = 0;
	stones = startBag;

	return self;

}

- (Stone *) getNextStone {
	
	Stone *rval = stones[nextStoneIndex];
	nextStoneIndex++;
	
	return rval;
	
}

- (NSInteger) getCount {
	
	NSInteger rval = 0;
	
	rval = [stones count] - nextStoneIndex;
	
	return rval;
	
}

- (Stone *) peekAtLastStone {
	// Used by a randomizer validation test case 
	return [stones objectAtIndex:59];
	
}

@end
