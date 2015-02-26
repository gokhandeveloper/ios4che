//
//  Global.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-28.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "Global.h"
#import "define.h"
#define wadourl = [txtWadoUrl.text]

@implementation Global


+ (Global *) sharedGlobal {
    static Global *sharedGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobal = [[self alloc] init];
    });
    return sharedGlobal;
}

- (id)init {
    if (self = [super init]) {
     
        self.strPatientId = @"";
        self.strPatientName = @"";
        self.strModality = @"ALL";
        self.strStartdDate = @"";
        self.strEndDate = @"";
        self.filterDateType = ANY_DATE;
       self.stIDNum = @"";
   //     self.wadoUrl = [txtWadoUrl.text];
       // self.nStudyIdNum = 10;
        self.nStudyIDNum = [_stIDNum intValue];
        self.nDicomIndex = -1;
        self.imageNumber = @"";
        self.arrDicomData = [[NSMutableArray alloc] init];
        
//        self.isFromModalityPickerToFilter = NO;
        self.isFromStartDatePickerToDateSelect = NO;
        self.isFromEndDatePickerToDateSelect = NO;

    }
    return self;
}

@end
