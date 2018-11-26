//
//  Stone.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "Stone.h"

@implementation Stone

- (id) initWithColor: (StoneColor) initColor idNumber:(int) initID {
    
    idNumber = initID;
    color = initColor;
    
    return self;
    
}

- (int) getStoneID {

    return idNumber;
    
}

@end
