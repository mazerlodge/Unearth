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

- (id) initWithGameDataDictionary: (NSDictionary *) dict {
    
    cli = [[CommandLineInterface alloc] init];
    gameState = @"NOT_POPULATED";
    
    if ([self populateGameFromDictionary:dict])
        gameState = @"POPULATED";
    else
        gameState = @"POPULATION_FAILED";
    
    return self;

}

- (bool) populateGameFromDictionary: (NSDictionary *) dict {
    
    bool bRval = true;
    
    // TODO: Add more dictionary parsing
    //      (e.g. grab delver cards, ruins deck, end of age card, stone bag, active wonders)
	
	cli = [dict objectForKey:@"CommandLineInterface"];
    players = [dict objectForKey:@"PlayerArray"];
    endOfAgeCard = [dict objectForKey:@"EndOfAgeCard"];
    stoneBag = [dict objectForKey:@"StoneBag"];
    
    // TODO: Add some validation of the above, for now assume it worked

    if (bRval)
        gameState = @"POPULATED";
    else
        gameState = @"POPULATION_FAILED";
    
    return bRval;
}

- (int) go {
    
    [cli put:@"Inside of UnearthGameEngine.\n"];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGE state = %@", gameState];
    [cli debugMsg:msg level:100];
    
    msg = [[NSString alloc] initWithFormat:@"Game has %ld players.\n", [players count]];
    [cli put:msg];
    
    return 0;
    
}

- (void) setGameState: (NSString *) newState {
    
    gameState = newState;
    
}

- (NSString *) gameState {
	return gameState;
	
}

@end
