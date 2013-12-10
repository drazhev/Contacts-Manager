//
//  ContactBook.m
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import "ContactBook.h"

@implementation ContactBook

+(id) sharedBook {
    static ContactBook *sharedBook = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBook = [[ContactBook alloc] init];
    });
    return sharedBook;
}

-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

-(id) init {
    if (self = [super init]) {
        NSArray* groups = @[@"Family", @"Work", @"Friends"];
        
        //NSMutableArray *firstGroup, *secondGroup, *thirdGroup;
        self.contactsDictionary = [[NSMutableDictionary alloc] initWithObjects:@[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]] forKeys:groups];
        for (int i=0; i<6; i++) {
            NSString* randomFirstName = [self genRandStringLength:7];
            NSString* randomLastName = [self genRandStringLength:8];
            NSString* randomNumber = [NSString stringWithFormat:@"08%u%07u", arc4random() % 3 + 7, arc4random() % 10000000];
            NSString* randomEmail = [NSString stringWithFormat:@"%@@gmail.com", [self genRandStringLength:15]];
            NSString* randomAddress = [self genRandStringLength:15];
            NSInteger randomGroup = arc4random() % [groups count];
            Contact* randomContact = [[Contact alloc] initWithFirstName:randomFirstName lastName:randomLastName phoneNumbers:[@[randomNumber] copy] emails:[@[randomEmail] copy] homeAddress:randomAddress picture:[UIImage imageNamed:@"defaultImage.png"] groupId:randomGroup];
            [[self.contactsDictionary objectForKey:groups[randomGroup]] addObject:randomContact];
        }

    }
    return self;
}

-(void)addContact: (Contact*) contact {
    if ([contact.phoneNumbers count] >= 1 && [contact.emails count] >= 1) {
        NSString* currentGroup = [self.contactsDictionary allKeys][contact.groupId];
        [[self.contactsDictionary objectForKey:currentGroup] addObject:contact];
    }
}

-(void)deleteContactWithGroupId:(NSInteger)groupId andContactId:(NSInteger)contactId {
    NSString* currentGroup = [self.contactsDictionary allKeys][groupId];
    if ([[self.contactsDictionary objectForKey:currentGroup] objectAtIndex:contactId]) {
        [[self.contactsDictionary objectForKey:currentGroup] removeObjectAtIndex:contactId];
    }
}

@end
