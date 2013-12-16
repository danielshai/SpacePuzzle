//
//  GViewViewController.m
//  SpacePuzzle

#import "SpacePuzzleController.h"
#import "BoardController.h"
#import "Element.h"
#import "Converter.h"
#import "Box.h"
#import "Star.h"
#import "Player.h"
#import "StarButton.h"
#import "BridgeButton.h"
#import "PlatformLever.h"
#import "Bridge.h"
#import "Path.h"
#import "Position.h"
#import "LoadSaveFile.h"
#import "LevelSceneFinal.h"

@implementation SpacePuzzleController
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize currentUnit = _currentUnit;
@synthesize nextUnit = _nextUnit;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize player = _player;
@synthesize world = _world;
@synthesize level = _level;
@synthesize boardController = _boardController;

-(void)viewDidLoad {
    [super viewDidLoad];
 
    // Configure the view.
    SKView *skView = (SKView *)self.view;
   // skView.showsFPS = YES;
   // skView.showsNodeCount = YES;
    
    // Create and configure the scene.

    self.levelSelect = [LevelSceneFinal sceneWithSize:skView.bounds.size];
    self.levelSelect.spCtrl = self;
    [skView presentScene:self.levelSelect];
}

-(void)startGameWithWorld: (NSInteger)world AndLevel: (NSInteger)level {
    _bigL = [[BigL alloc] init];
    _littleJohn = [[LittleJohn alloc] init];
    
    swipeArray = [[NSMutableArray alloc] init];
    
    [LoadSaveFile saveFileWithWorld:world andLevel:level];
    _boardController = [[BoardController alloc] init];
    _boardController.spController = self;
    _boardController.scene = _scene;
    
    [self setupNextLevel];
    
    // Present the scene.
    //SKView *view = (SKView*)self.view;
    //[view presentScene:_scene];
    //self.levelSelect = nil;
    
    // Removes old gesture recognizers.
    for (id gest in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gest];
    }
    
    // Gesture recognizers.
    UITapGestureRecognizer *singleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapR.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapR];
    
    UITapGestureRecognizer *doubleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(doubleTap:)];
    doubleTapR.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapR];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(checkInteraction:) userInfo:nil repeats:YES];
}

/*
 *  Called when the user taps once. */
-(void)singleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = [sender locationInView:_scene.view];
        
        // Convert to board coordinates.
        location = [Converter convertMousePosToCoord:location];
        [self unitWantsToMoveTo:location WithSwipe:NO];
    }
}

/* 
 *  Called when the user double taps the view. */
-(void)doubleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = [sender locationInView:_scene.view];
        
        location = [Converter convertMousePosToCoord:location];
    
        [self unitWantsToDoActionAt:location];
    }
}

-(void)swipeUp:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y -= 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    } else {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y -= 1;
        Position *pos = [[Position alloc] initWithX:location.x Y:location.y];
        [swipeArray addObject: pos];
    }
}

-(void)swipeDown:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y += 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    } else {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y += 1;
        Position *pos = [[Position alloc] initWithX:location.x Y:location.y];
        [swipeArray addObject: pos];
    }
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x -= 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    } else {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x -= 1;
        Position *pos = [[Position alloc] initWithX:location.x Y:location.y];
        [swipeArray addObject: pos];
    }
}

-(void)swipeRight:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x += 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    } else {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x += 1;
        Position *pos = [[Position alloc] initWithX:location.x Y:location.y];
        [swipeArray addObject: pos];
    }
}

-(void)checkInteraction:(NSTimer *)time {
    if(![_scene hasActions]){
        for (int i = 0; i < swipeArray.count; i++) {
            Position *pos = [swipeArray objectAtIndex:i];
            CGPoint nextLoc = CGPointMake(pos.x, pos.y);
            [self unitWantsToMoveTo:nextLoc WithSwipe:YES];
        }
        [swipeArray removeAllObjects];
    }
}

-(void)changeUnit {
    if (_currentUnit == _bigL) {
        if([_littleJohn isPlayingOnLevel]) {
            _currentUnit = _littleJohn;
            _nextUnit = _bigL;
            [_scene changeUnit];
            NSLog(@"Change unit");
        }
        NSLog(@"Can't change, only L");
    } else if(_currentUnit == _littleJohn) {
        if([_bigL isPlayingOnLevel]) {
            _currentUnit = _bigL;
            _nextUnit = _littleJohn;
            [_scene changeUnit];
        }
    }
}

/*
 *  Is called when the animation of moving a unit is finished. Checks if the units are on the finish point,
 *  if so setup next level. Also, checks if unit should fall after moving. */
-(void)sceneFinishedMovingUnit {
    // If the player moved to the finish, new level.
    CGPoint to = CGPointMake(_currentUnit.x, _currentUnit.y);
    [_boardController updateElementsMovedToPoint:to];
    if([self areUnitsOnFinish]) {
        _level++;
        if(_level > 10) {
            _level = 1;
            _world++;
        }
        [LoadSaveFile saveFileWithWorld:_world andLevel:_level];
        [self setupNextLevel];
    }
    
    [self checkIfUnitShouldFall];
}

-(void)sceneFinishedMovingElementFrom:(CGPoint)from WithIndex:(NSInteger)index To:(CGPoint)to {
    NSInteger dir = [Converter convertCoordsTo:to Direction:from];
    [_boardController boxMovedToPoint:to FromPoint:from InDirection: dir];
    [self checkIfUnitShouldFall];
}

-(void)checkIfUnitShouldFall {
    CGPoint bigLPos = CGPointMake(_bigL.x, _bigL.y);
    CGPoint littleJohnPos = CGPointMake(_littleJohn.x, _littleJohn.y);
    
    if (![_boardController isPointMovableTo:bigLPos] && _bigL.isPlayingOnLevel) {
        [_scene unitFallingAnimation:BIG_L];
    }
    if (![_boardController isPointMovableTo:littleJohnPos] && _littleJohn.isPlayingOnLevel) {
        [_scene unitFallingAnimation:LITTLE_JOHN];
    }
}

/*
 *  Loads the board according to the level. ADD LEVELFACTORY!!!. */
-(void)setupBoard {
    // Load the board.
    [self getNextLevel];
    NSString *currentLevel = @"Level";
    currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)_world]];
    if(_level < 10) {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d%ld", 0, (long)_level]];
    } else {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)_level]];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:currentLevel ofType:@"splvl"];
    NSLog(@"%@", currentLevel);
   
    [_board loadBoard:path];
    
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:BOARD_SIZE_X*i + j];
            [_scene setupBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
    CGPoint p = CGPointMake(_board.finishPos.x, _board.finishPos.y);
    p = [Converter convertCoordToPixel:p];
    p.x += TILESIZE/2;
    p.y -= 2;
    [_scene finish].position = p;
}

-(void)setupElements {
    // Talk to the scene what to show.
    
    for(id key in [[_boardController board] elementDictionary]) {
        NSMutableArray *arr = [[[_boardController board] elementDictionary] objectForKey:key];
        // atIndex:0 is because, currently, boards cannot have 2 elements in the beginning.
        Element *e = [arr objectAtIndex:0];
        CGPoint elementPos = CGPointMake(e.x, e.y);
        [_scene updateElementsAtPosition:elementPos withArray:arr];
    }
}

/*
 *  Called when a unit wants to move to a location on the board. This method checks if the move is 
 *  possible, if so moves the unit. If unit moves to star, consume the star. */
-(void)unitWantsToMoveTo:(CGPoint)loc WithSwipe:(BOOL)swipe {
    // The position that the unit wants to move to.
    NSInteger x  = loc.x;
    NSInteger y = loc.y;
    
    // NSInteger nextPosIntKey = [nextPosKey integerValue];
    // The unit who wants to move's position.
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    CGPoint from = CGPointMake(unitX, unitY);
    CGPoint to = CGPointMake(x, y);

    NSInteger dir = [Converter convertCoordsTo:to Direction:from];
    // First check if the movement is possible on the board and the move isn't to the same point or
    // diagonally.

    // Move unit in data model and view.
    if([_boardController unitWantsToMoveFrom:from To:to WithSwipe:swipe UnitWasAstronatut:_currentUnit == _bigL]) {
        _currentUnit.x = x;
        _currentUnit.y = y;

        [_scene updateUnit:to inDirection:dir];
        [_scene refreshTileAtPosition:from WithStatus:[_boardController getBoardStatusAtPosition:from]];
    }
    
    // Check if going in a longer straight line.
    
}

-(void)takeStar {
    _player.starsTaken++;
}

/*
 *  Called when a unit (i.e. the user) wants to do an action. First checks if the action is possible,
 *  then chooses an action based on what element the action is performed on. */
-(void)unitWantsToDoActionAt:(CGPoint)loc {
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    
    CGPoint unitPoint = CGPointMake(unitX, unitY);
    
    [_boardController unitWantsToDoActionAt:loc From:unitPoint IsBigL:_currentUnit == _bigL];
}

/*
 *  Does action on a star button, i.e. turns it on/off. */
-(void)doActionOnStarButton:(Element *)button {
    StarButton *sb = (StarButton*)button;
    [sb movedTo];
    
    // Updates the button on the scene.
    [_scene refreshElementAtPosition:sb.key OfClass:CLASS_STARBUTTON WithStatus:sb.state];
    // Updates the star connected to the button on the scene, i.e. showing it.
    if(!sb.star.taken) {
        [_scene setElementAtPosition:sb.star.key IsHidden:sb.star.hidden];
        
        CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
        CGPoint nextUnitPos = CGPointMake(_nextUnit.x, _nextUnit.y);
        // If the other unit is standing on the same spot as the star and button is on the star should be
        // taken by the player.
        if([Converter isPoint:starPos sameAsPoint:nextUnitPos] && sb.state) {
            
        }
    }
}

-(void)doActionOnBridgeButton: (Element*)button {
    BridgeButton *bb = (BridgeButton*)button;
    [bb movedTo];
    
    // Updates the button on the scene.
    [_scene refreshElementAtPosition:bb.bridge.key OfClass:CLASS_BRIDGE WithStatus:bb.state];
    [_scene refreshElementAtPosition:bb.key OfClass:CLASS_BRIDGEBUTTON WithStatus:bb.state];
    // Updates the bridge connected to the button on the scene, i.e. showing it.
    [_scene setElementAtPosition:bb.bridge.key IsHidden:NO];
}

// Moving platform should have TIMER in it.
-(void)doActionOnPlatformLever:(Element *)lever {
    PlatformLever *pl = (PlatformLever*)lever;
    [pl doAction];
    // Updates the lever on the scene.
    [_scene refreshElementAtPosition:pl.key OfClass:CLASS_LEVER WithStatus:pl.state];
    // Updates the moving platform connected to the lever on the scene, i.e. moving it.
    [_scene setElementAtPosition:pl.movingPlatform.key IsHidden:NO];
    [_scene refreshElementAtPosition:pl.movingPlatform.key OfClass:CLASS_MOVING_PLATFORM
                          WithStatus:pl.movingPlatform.blocking];
    
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self
                                   selector:@selector(movePlatform:)  userInfo:pl.movingPlatform
                                    repeats:YES];
}

-(void)movePlatform:(NSTimer *)timer {
    // TEMP CODE.
    MovingPlatform *mp = [timer userInfo];
    [[_board elementDictionary] removeObjectForKey:mp.key];
    
    CGPoint prevPoint = CGPointMake(mp.x, mp.y);
    if(mp) {
        CGPoint p = mp.path.nextPoint;
        mp.x = p.x;
        mp.y = p.y;
        
        NSInteger dir = [Converter convertCoordsTo:prevPoint Direction:p];
        
        if(_littleJohn.x == prevPoint.x && _littleJohn.y == prevPoint.y) {
            _littleJohn.x = mp.x;
            _littleJohn.y = mp.y;
            [_scene updateUnit:CGPointMake(_littleJohn.x, _littleJohn.y) inDirection:dir];
        }
        
        if(_bigL.x == prevPoint.x && _bigL.y == prevPoint.y) {
            _bigL.x = mp.x;
            _bigL.y = mp.y;
            [_scene updateUnit:CGPointMake(_bigL.x, _bigL.y) inDirection:dir];
        }
    }
    [[_board elementDictionary] setObject:mp forKey:mp.key];
    NSLog(@"%f %f --- %ld %ld",prevPoint.x,prevPoint.y,(long)mp.x,(long)mp.y);
    
    // Check if unit is on platform, if so move it.
    NSLog(@"%ld %ld", (long)_bigL.x, (long)_bigL.y);
    
    //[_scene moveElement:prevPoint NewCoord:CGPointMake(mp.x, mp.y) Onto:MAPSTATUS_SOLID InDir:0];
}

/*
 *  Checks if the |currentUnit| is on the finish position. */
-(BOOL)areUnitsOnFinish {
    CGPoint finishPoint = CGPointMake(_boardController.board.finishPos.x, _boardController.board.finishPos.y);
    CGPoint currentUnitPoint = CGPointMake(_currentUnit.x, _currentUnit.y);
    CGPoint nextUnitPoint = CGPointMake(_nextUnit.x, _nextUnit.y);
    
    return [Converter isPoint:finishPoint sameAsPoint:currentUnitPoint]
        && [Converter isPoint:finishPoint sameAsPoint:nextUnitPoint];
}

-(NSArray*) getDataFromNotification:(NSNotification *)notif Key:(NSString *)key {
    NSDictionary *userInfo = notif.userInfo;
    NSSet *objectSent = [userInfo objectForKey:key];
    return [objectSent allObjects];
}

/*
 *  Sets |level| and |world| according to the level progress. */
-(void)getNextLevel {
    if([LoadSaveFile loadFile]) {
        NSString *currentState = [LoadSaveFile loadFile];
        _world = [[currentState substringWithRange:NSMakeRange(5, 1)] integerValue];
        if([[currentState substringWithRange:NSMakeRange(6, 1)] integerValue] != 0){
            _level = [[currentState substringWithRange:NSMakeRange(6, 2)] integerValue];
        } else {
            _level = [[currentState substringWithRange:NSMakeRange(7, 1)] integerValue];
        }
        _player = [[Player alloc] initWithWorld:_world andLevel:_level];
    } else {
        _player = [[Player alloc] initWithWorld:0 andLevel:1];
    }
}

/*
 *  Creates the units. */
-(void)setupUnits {
    _bigL.x = _boardController.board.startPosAstronaut.x;
    _bigL.y = _boardController.board.startPosAstronaut.y;
 
    // If the unit has a valid starting position, it is playing.
    if(_bigL.x >= 0 && _bigL.y >= 0) {
        _bigL.isPlayingOnLevel = YES;
    } else {
        _bigL.isPlayingOnLevel = NO;
    }
    
    _littleJohn.x = _boardController.board.startPosAlien.x;
    _littleJohn.y = _boardController.board.startPosAlien.y;
    
    if(_littleJohn.x >= 0 && _littleJohn.y >= 0) {
        _littleJohn.isPlayingOnLevel = YES;
    } else {
        _littleJohn.isPlayingOnLevel = NO;
    }
    
    if(_bigL.isPlayingOnLevel && !_littleJohn.isPlayingOnLevel) {
        NSLog(@"Only L");
        _currentUnit = _bigL;
        _nextUnit = _bigL;
    } else if(!_bigL.isPlayingOnLevel && _littleJohn.isPlayingOnLevel) {
        NSLog(@"Only John");
        _currentUnit = _littleJohn;
        _nextUnit = _littleJohn;
    } else if([_bigL isPlayingOnLevel] && [_littleJohn isPlayingOnLevel]) {
        // If both are playing, set astronaut as starting unit as default.
        _currentUnit = _bigL;
        _nextUnit = _littleJohn;
    }
    
    // Units in scene.
    CGPoint pA = CGPointMake(_bigL.x, _bigL.y);
    [_scene setupAstronaut:pA];
    CGPoint pAl = CGPointMake(_littleJohn.x, _littleJohn.y);
    
    [_scene setupAlien:pAl];
    [_scene setCurrentUnitWithMacro:[self currentUnitToMacro]];
}

-(NSInteger)currentUnitToMacro {
    if(_currentUnit == _bigL) {
        return BIG_L;
    } else if(_currentUnit == _littleJohn) {
        return LITTLE_JOHN;
    }
    return -1;
}

-(void)setupNextLevel {
    [self getNextLevel];
    [_boardController setupBoardWithWorld:_world AndLevel:_level];
    [swipeArray removeAllObjects];
    [self setupScene];
    [self setupElements];
    [self setupUnits];
}

-(void)setupScene {
    [_scene cleanScene];
    // Board in scene.
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            CGPoint p = CGPointMake(j, i);
            [_scene setupBoardX:j Y:i Status:[_boardController getBoardStatusAtPosition:p]];
        }
    }
    CGPoint p = CGPointMake(_boardController.board.finishPos.x, _boardController.board.finishPos.y);
    p = [Converter convertCoordToPixel:p];
    p.x += TILESIZE/2;
    p.y -= 2;
    [_scene finish].position = p;
}

/*
 *  Adds a notification to listen to from this class. */
-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(void)updateElementsAtPosition:(CGPoint)pos withArray:(NSMutableArray *)elArr {
    [_scene updateElementsAtPosition:pos withArray:elArr];
}

-(NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)moveElementFrom: (CGPoint)oldCoord WithIndex: (NSInteger)elementIndex To: (CGPoint)newCoord OntoStatus:(NSInteger)status InDir:(NSInteger)direction; {
    [_scene moveElementFrom:oldCoord WithIndex:elementIndex To:newCoord OntoStatus:status InDir:direction];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)changeUnitAction:(id)sender {
    [self changeUnit];
}

- (IBAction)restartAction:(id)sender {
    [self setupNextLevel];
}
@end
