//
//  main.m
//  Unearth
//
//  Created by mazerlodge on 6/16/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArgParser.h"
#import "UnearthGameFactory.h"
#import "UnearthGameEngine.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // Copy args into an array.
        NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:argc];
        for (int x=0; x<argc; x++) {
            NSString *currentArg = [[NSString alloc] initWithCString:argv[x] encoding:NSASCIIStringEncoding];
            [args addObject:currentArg];
        }

        // Run arg parser tests
        ArgParser *argParser = [[ArgParser alloc] initWithArgs:args];

        // Instantiate UE Factory, get an instance of a game engine, and start it.
        UnearthGameFactory *ugf = [[UnearthGameFactory alloc] initWithArgParser:argParser];
        if (![ugf validateArguments:argParser]) {
            [ugf showUsage];
            return 255;
        }
        
        UnearthGameEngine *uge = [ugf makeGameWithArgs:argParser];
        [uge go]; 
        
        
        
    }
    return 0;
}
