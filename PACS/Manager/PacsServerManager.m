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
 //test to see if it works.
//        PacsServer *firstServer = [[PacsServer alloc] init];
//        firstServer.pacsName = @"HelloCHiro";
//        firstServer.username = @"Admin";
//        firstServer.password = @"Unknown";
//        firstServer.wadoUrl = @"10.0.0.12";
//
//        PacsServer *secondServer = [[PacsServer alloc] init];
//        secondServer .pacsName = @"CatVet";
//        secondServer .username = @"user";
//        secondServer .password = @"user";
//        secondServer .wadoUrl = @"192.1.1.1";
//       _pacsServers = [NSMutableArray arrayWithObjects:firstServer,secondServer, nil];
        
       
        self.pacsDataInStringArray=@"";
        self.pacsName=@"";
        self.username=@"";
        self.password=@"";
        self.wadoUrl= @"";
        self.apiDirectory=@"";
        self.switchPosition=@"";
    }
    return self;
}

@end
