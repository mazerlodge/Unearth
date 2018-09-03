//
//  UnearthGameFactory.h
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnearthGameEngine.h"
#import "ArgParser.h"
#import "UnearthPlayer.h"
#import "CommandLineInterface.h"

@interface UnearthGameFactory : NSObject {
    
    NSArray *delverDeckInfo;
    
}

/*
 Method list from [Object Library.txt]
 - wondersDeckInfo    // 15x named, 10x lesser, 6x greater
 - delverDeckInfo     // 38x generated from n original possibilities
 - endOfAgeDeckInfo    //  5x, shuffled for game, top card used in this game run.
 
 + makeGame;         // Crates game with development test set of args
 + makeGameWithArgs: argParser
 + makeDelverDeck;
 + makeRuinsDeck;
 + makeNamedWonders;
 + makeStoneBag;
 + makeEndOfAgeCard;
 + makePlayer: name withType: intType dieColor: UEDieColor

 */

- (void) showUsage;
- (int) doTest: (NSInteger) testNumber;
- (bool) validateArguments: (ArgParser *) argParser;
- (UnearthGameEngine *) makeGame;
- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) ap;


@end
