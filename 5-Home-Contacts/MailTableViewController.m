//
//  SecondViewController.m
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import "MailTableViewController.h"

@interface MailTableViewController ()

@property (nonatomic,strong) ContactBook* contactsModel;
@property (nonatomic,weak) NSIndexPath* selectedIndexPath;

@end

@implementation MailTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateTableView:) name:@"updateTable" object:nil];
    self.contactsModel = [ContactBook sharedBook];
    self.tabBarController.tabBar.translucent = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)updateTableView: (NSNotification*) not {
    [self.tableView reloadData];
}

-(void)addButtonTapped: (id)sender {
    [self performSegueWithIdentifier:@"newContactSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"emailSegue" sender:self];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"emailSegue"]) {
        SendMailViewController* destVC = segue.destinationViewController;
        NSString* currentGroup = [self.contactsModel.contactsDictionary allKeys][self.selectedIndexPath.section];
        Contact* currentContact = [self.contactsModel.contactsDictionary objectForKey:currentGroup][self.selectedIndexPath.row];
        destVC.recipientEmail = currentContact.emails[0];
    }
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
    return self.contactsModel.groupsArray[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"contactCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString* currentGroup = [self.contactsModel.contactsDictionary allKeys][indexPath.section];
    Contact* currentContact = [self.contactsModel.contactsDictionary objectForKey:currentGroup][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentContact.firstName, currentContact.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)dealloc {
    // I know while using ARC, dealloc is not needed
    // but removing an observer is mandatory still
    // and this is the best method to do so
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // no need to call [super dealloc] though, because ARC does it
}

@end
