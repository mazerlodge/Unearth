//
//  UnearthGameEngine.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameEngine.h"

@implementation UnearthGameEngine

- (id) init {
    cli = [[CommandLineInterface alloc] init];
    
    gameState = @"NOT_POPULATED";
    
    return self;
    
}

- (int) go {
    
    [cli put:@"Inside of UnearthGameEngine.\n"];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGE state = %@\n", gameState];
    [cli put:msg];
    
    return 0;
    
}

- (void) setGameState: (NSString *) newState {
    
    gameState = newState;
    
}


@end
