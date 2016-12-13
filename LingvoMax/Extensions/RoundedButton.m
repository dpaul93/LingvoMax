//
//  RoundedButton.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = self.bounds.size.height / 3;
    }
    
    return self;
}

@end
