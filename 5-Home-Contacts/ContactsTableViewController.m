//
//  FirstViewController.m
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@property (nonatomic, strong) ContactBook* contactsModel;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"All contacts";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.tabBarController.tabBar.translucent = NO;
    self.contactsModel = [ContactBook sharedBook];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)addButtonTapped: (id)sender {
    [self performSegueWithIdentifier:@"newContactSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.contactsModel.contactsDictionary allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* keys = [self.contactsModel.contactsDictionary allKeys];
    NSMutableArray* currentGroup = [self.contactsModel.contactsDictionary objectForKey:keys[section]];
    return currentGroup.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.contactsModel.contactsDictionary allKeys][section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"contactCell";
    ContactsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString* currentGroup = [self.contactsModel.contactsDictionary allKeys][indexPath.section];
    Contact* currentContact = [self.contactsModel.contactsDictionary objectForKey:currentGroup][indexPath.row];
    cell.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@", currentContact.firstName, currentContact.lastName];
    cell.contactPhoneLabel.text = currentContact.phoneNumbers[0];
    cell.contactEmailLabel.text = currentContact.emails[0];
    cell.contactImageView.image = currentContact.picture;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.contactsModel deleteContactWithGroupId:indexPath.section andContactId:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString* movedContactGroup = [self.contactsModel.contactsDictionary allKeys][sourceIndexPath.section];
    Contact* movedContact = [self.contactsModel.contactsDictionary objectForKey:movedContactGroup][sourceIndexPath.row];
    [[self.contactsModel.contactsDictionary objectForKey:movedContactGroup] removeObjectAtIndex:sourceIndexPath.row];
    NSString* destinationContactGroup = [self.contactsModel.contactsDictionary allKeys][destinationIndexPath.section];
    [[self.contactsModel.contactsDictionary objectForKey:destinationContactGroup] insertObject:movedContact atIndex:destinationIndexPath.row];
}

@end
