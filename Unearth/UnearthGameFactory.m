//
//  UnearthGameFactory.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameFactory.h"

@implementation UnearthGameFactory

- (id) init {
    
    return self;
    
}

- (UnearthGameEngine *) makeGame {
    
    // TODO: Define set of test params to be used with this generic method.
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];
    
    // TODO: Create a populated ArgParser object, may require new 'argParserFromString' type method.
    
    return uge;
    
    
}

- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) ap {
    
    // TODO: Evaluate ArgParser to determine details of game build.

    // TODO: Define set of test params to be used with this generic method.
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];

    return uge;
    
}


@end
