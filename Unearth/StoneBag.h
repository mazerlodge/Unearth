//
//  StoneBag.h
//  Unearth
//
//  Created by Paul Sorenson on 1/26/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stone.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoneBag : NSObject {
	
	int nextStoneIndex;
	NSArray *stones;
	
}

- (id) initWithStoneBag: (NSArray *) startBag;
- (Stone *) getNextStone;
- (NSInteger) getCount;

// For a test...
- (Stone *) peekAtLastStone;

@end

/*
 .> StoneBag
 - stones 			// array of stones
 - pullStone() 		// retrieves next stone from bag
 */

NS_ASSUME_NONNULL_END
