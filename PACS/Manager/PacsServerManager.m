//
//  PacsServerManager.m
//  com.ios4che
//
//  Created by gokhan on 18/03/2015.
//  Copyright (c) 2015 Gokhan DIlek. All rights reserved.
//

#import "PacsServerManager.h"
#import "PacsServer.h"
@implementation PacsServerManager

+(instancetype)pacsManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id) init {
    
    if(self =[super init]){
        
        PacsServer *server= [[PacsServer alloc] init];
        
        _pacsServers = [NSMutableArray arrayWithObjects:server, nil];
    }
    
    return self;
}

@end
