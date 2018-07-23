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

/*
bool validateArguments(ArgParser *argParser) {
    // Return true if the params specified are valid and complete.
    
    bool bRval = true;
    NSString *action = @"NOT_SET";

    if ([argParser isInArgs:@"-action" withAValue:true]) {
        action = [argParser getArgValue:@"-action"];
    }
    else {
        NSLog(@"Error: Missing required parameter: -action.  Can not continue.\n");
        bRval = false;
    }
    
    // If action is dotest, must also have a -test arg w/ a test number.
    if (([action isEqualToString:@"dotest"])
         && (![argParser isInArgs:@"-test" withAValue:true])) {
        NSLog(@"Error: Detected -action of dotest, missing required parameter: -test testID.  Can not continue.\n");
        bRval = false;
    }

    if ([argParser isInArgs:@"-debug" withAValue:false])
        NSLog(@"Info: Debug parameter detected.\n");
    
    
    return bRval;
    
}

void showUsage() {
    // Display appropriate invocation options.
    
    printf("Usage: unearth -action {dotest} -test 1 \n");
    
    
}

*/

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // Instantiate UE Factory, get an instance of a game engine, and start it.
        UnearthGameFactory *ugf = [[UnearthGameFactory alloc] init];

        // Copy args into an array.
        NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:argc];
        for (int x=0; x<argc; x++) {
            NSString *currentArg = [[NSString alloc] initWithCString:argv[x] encoding:NSASCIIStringEncoding];
            [args addObject:currentArg];
        }
        
        // Run arg parser tests
        ArgParser *argParser = [[ArgParser alloc] initWithArgs:args];
        if (![ugf validateArguments:argParser]) {
            [ugf showUsage];
            return 255;
        }
        
        UnearthGameEngine *uge = [ugf makeGameWithArgs:argParser];
        [uge go];
        
        
        
    }
    return 0;
}
