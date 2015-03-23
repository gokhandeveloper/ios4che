//
//  PacsServer.h
//  com.ios4che
//
//  Created by gokhan on 17/03/2015.
//  Copyright (c) 2015 Gokhan DIlek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacsServer : NSObject
@property ( nonatomic) NSString *pacsName;
@property (nonatomic) NSString*username;
@property ( nonatomic) NSString*password;
@property (nonatomic) NSString *wadoUrl;
@property ( nonatomic) NSString *apiDirectory;
@property ( nonatomic) NSString *dataArrayIncludesUsernamePasswordWadoLoginWebServiceAndSecurity;

@end
