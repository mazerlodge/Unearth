//
//  UnearthGameEngine.h
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLineInterface.h"
#import "UnearthPlayer.h"
#import "EndOfAgeCard.h"
#import "Stone.h"
#import "StoneBag.h"
#import "RuinDeck.h"

@interface UnearthGameEngine : NSObject {
    
    NSString *gameState;
    CommandLineInterface *cli;
    NSArray *delverDeck;
	RuinDeck *ruinsDeck;
	NSArray *ruinsInBox; // Top 5 cards are put in box at game start.
    NSArray *players;
    StoneBag *stoneBag;
    EndOfAgeCard *endOfAgeCard;
	
	int currentDelverDeckIdx;
	int currentRuinsDeckIdx;
    
}

- (id) initWithGameDataDictionary: (NSDictionary *) dict;
- (int) go;
- (void) setGameState: (NSString *) newState;
- (bool) populateGameFromDictionary: (NSDictionary *) dict;

- (NSString *) gameState;


/*
 Method list from [Object Library.txt]
 > UnearthGameEngine
 - delverDeck        // 38x, each one of 11 possible types
 - ruinsDeck            // 25x
 - namedWonders         // named wonders selected for this game run.
 - ruinsStack        // ruins selected for this game run.
 - ruinsActive         // current face up ruins available for delving.
 - endOfAgeCard      // the end card for this game run
 - stoneBag            // initial stones for this game run (randomized)
 - players             // player objects for this game run.
 
 */


@end
