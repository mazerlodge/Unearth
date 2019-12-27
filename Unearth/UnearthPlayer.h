//
//  UnearthPlayer.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DelverDie.h"
#import "DelverCard.h"
#import "RuinCard.h"
#import "RandomEngine.h"

typedef enum UnearthPlayerType : NSUInteger {
    UnearthPlayerHuman = 0,
    UnearthPlayerAI = 1
} UnearthPlayerType;

typedef enum PlayerActionEnum : NSUInteger {
	PlayerActionNotSet = 0,
	PlayerActionHelp = 1,
	PlayerActionQuit = 2,
    PlayerActionDone = 3,
	PlayerActionShow = 4,
    PlayerActionRoll = 5
} PlayerAction;

typedef enum PlayerActionTargetEnum : NSUInteger {
	PlayerActionTargetNotSet = 0,
	PlayerActionTargetHelp   = 1,
	PlayerActionTargetDelver = 2,
	PlayerActionTargetDice   = 3,
    PlayerActionTargetMap    = 4,
	PlayerActionTargetRuin   = 5,
    PlayerActionTargetWonder = 6
} PlayerActionTarget;

typedef enum PlayerActionTargetLocationEnum : NSUInteger {
	PlayerActionTargetLocationNotSet = 0,
	PlayerActionTargetLocationHelp   = 1,
	PlayerActionTargetLocationHand   = 2,
	PlayerActionTargetLocationBoard  = 3
} PlayerActionTargetLocation;


@interface UnearthPlayer : NSObject {
    
    NSString *playerName;
    UnearthPlayerType playerType;
    DelverDieColor dieColor;
	NSMutableArray *delverCards;
	NSMutableArray *ruinCards;
	RandomEngine *re;
	
}

- (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name randomEngine: (RandomEngine *) randomEngine;


- (DelverDieColor) dieColor;
- (NSString *) playerName;
- (NSUInteger) addDelverCard: (DelverCard *) card;
- (NSUInteger) addRuinCard: (RuinCard *) card;
- (DelverCard *) playDelverCard: (int) cardID;
- (NSString *) showDelverCards;
- (int) roleDie: (DelverDieSize) dieSize;
- (UnearthPlayerType) getPlayerType;
- (NSString *) toString;
- (PlayerAction) parsePlayerActionFromString: (NSString *) phrase;
- (PlayerActionTarget) parsePlayerActionTargetFromString: (NSString *) phrase;
- (PlayerActionTargetLocation) parsePlayerActionTargetLocationFromString: (NSString *) phrase;
- (NSString *) showPlayerActionHelp;
- (NSString *) showPlayerActionTargetHelp;
- (NSString *) showPlayerActionTargetLocationHelp;



/*
 Method list from [Object Library.txt]
 > UnearthPlayer
 - name                // For output and identification
 - type                 // human or ai
 - dieColor            // one of red, green, yellow, blue, to come from DelverDie.h based enum.
 - delverCards        // current delver cards held by this player
 - delverDice         // current held delver dice, available to roll
 - ruinsCards         // includes one faceDown
 - hexMap            // arrangement of owned stones and wonders
 
 */

@end
