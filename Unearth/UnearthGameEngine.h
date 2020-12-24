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
#import "Wonder.h"

typedef enum GameStateEnum : NSInteger {
	GameStatePopulationFailed = -2,
	GameStateError = -1,
    GameStateNotPopulated = 0,
    GameStatePopulated = 1,
    GameStateRunning = 2,
	GameStateDelverPhase = 21,
	GameStateExcavationPhase = 22,
    GameStateQuit = 3
} GameState;

@interface UnearthGameEngine : NSObject {
    
    GameState gameState;
    CommandLineInterface *cli;
    NSArray *delverDeck;
	RuinDeck *ruinsDeck;
	NSArray *lesserWondersDeck;
	NSArray *greaterWondersDeck;
	NSArray *namedWondersDeck;
	NSArray *ruinsInBox; // Top 5 cards are put in box at game start.
	NSArray *ruinsOnTable;
	NSArray *namedWondersOnTable;
    NSArray *players;
    StoneBag *stoneBag;
    EndOfAgeCard *endOfAgeCard;
	
	NSArray *delverCardsInPlay;
	
	int currentDelverDeckIdx;
	int currentRuinsDeckIdx;
	int currentLesserWonderIdx;
	int currentGreaterWonderIdx;
	int currentNamedWonderIdx;
	int currentPlayerIdx;
	

}

+ (NSString *) GameStateToString: (GameState) gameState;

- (id) initWithGameDataDictionary: (NSDictionary *) dict;

- (int) go;

- (void) setGameState: (GameState) newState;
- (bool) populateGameFromDictionary: (NSDictionary *) dict;

- (GameState) gameState;

- (Wonder *) getWonderByID: (NSUInteger) objectID;


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
