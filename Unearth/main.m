//
//  main.m
//  Unearth
//
//  Created by mazerlodge on 6/16/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArgParser.h"

bool validateArguments(ArgParser *argParser) {
    // Return true if the params specified are valid and complete.
    
    bool bRval = true;
    
    if ([argParser isInArgs:@"-debug" withAValue:false])
        NSLog(@"Debug parameter detected.\n");
    
    if ([argParser isInArgs:@"-forcefail" withAValue:true]
        && ([argParser doesArg:@"-forcefail" haveValue:@"yes"]))
               bRval = false;
    
    return bRval;
    
}

void showUsage() {
    // Display appropriate invocation options.
    
    printf("Usage: unearth -debug -forcefail {yes | no}\n");
    
    
}

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
        if (!validateArguments(argParser)) {
            showUsage();
            return 255;
        }
        
        // ToDo: Instantiate and start unearth engine.
        
        
    }
    return 0;
}
