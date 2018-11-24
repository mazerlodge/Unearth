//
//  RuinCard.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "RuinCard.h"

@implementation RuinCard

- (id) initWithColor: (RuinCardColor) color claimValue: (int) claimVal stoneValue: (int) stoneVal {
    
    bFaceDown = true;
    cardColor = color;
    claimValue = claimVal;
    stoneValue = stoneVal;
    
    stones = [[NSMutableArray alloc] initWithCapacity:stoneVal];
    delverDice = [[NSMutableArray alloc] init];
    
    return self;
    
}

@end
