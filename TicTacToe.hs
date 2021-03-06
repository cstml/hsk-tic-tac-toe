module TicTacToe
  ( play )
where

maybeRead :: Read a => String -> Maybe a
maybeRead s = case reads s of
                [(x,"")] -> Just x
                _        -> Nothing

data XO = X | O  deriving (Show,Eq)

type Player = XO

type Space = Maybe XO

type Board = [Space]
type Pos = Int
type PlayerChoice = (Player,Pos)
type GameState = Board 

initState :: Board
initState = take 9 $ repeat Nothing

makeMove :: GameState -> PlayerChoice -> GameState
makeMove g c
  | valid c   = place g c
  | otherwise = error "Not a valid choice - Position is Full"
  where
    place ::  GameState -> PlayerChoice -> GameState
    place (g:gs) (p,  1)  = Just p : gs
    place (g:gs) (p,pos)  = g : place gs (p, pos-1) 
      
    valid :: PlayerChoice -> Bool
    valid (_, p)
      | p < 0                       = False
      | p > 9                       = False
      | board !! (p-1) /= Nothing   = False
      | otherwise                   = True
      where
        board = g

printB :: Board -> IO()
printB [] = print ""
printB b  = print (take 3 b) >>= \_ -> printB  (drop 3 b)

gameLoop :: Board -> Player -> IO()
gameLoop st pl 
  | won st    = printB st >> print ("Player " ++ show otP ++ " Won!")
  | draw st   = printB st >> print ("It's a draw !")
  | otherwise = 
      print "Current State" >> printB st >>
      print ("Player " ++ show pl ++ " to go!") >>
      getLine >>= \inp ->
      return (maybe 0 r  (maybeRead inp)::Int) >>= \pInp ->
      case isValid pInp of
        True -> gameLoop (aux pInp pl st) otP
        _    -> print "Bad Input \n Try again! with a number from 1-9!" >> gameLoop st pl
  where

    r = \x -> x
    
    aux :: Int -> Player -> Board -> Board
    aux po pl b = makeMove b (pl,po)

    isValid :: Int -> Bool
    isValid x =  x > 0
             &&  x < 10
             && (st !! (x-1)) == Nothing
    
    otherPlayer :: XO -> XO
    otherPlayer X = O
    otherPlayer O = X
        
    otP = otherPlayer pl
        
    draw :: Board -> Bool
    draw x = foldl1 (&&) (fmap (\z -> z /= Nothing) x)
        
    -- Probably should have made a nicer function but I like it this way
    won :: Board -> Bool
    won (a : b : c :
         d : e : f :
         g : h : i : [])
      | a == b && b == c && c /= Nothing = True -- l1
      | d == e && e == f && d /= Nothing = True -- l2
      | g == h && h == i && i /= Nothing = True -- l3
      | a == e && e == i && i /= Nothing = True -- d1
      | g == e && e == c && c /= Nothing = True -- d2
      | a == d && d == g && g /= Nothing = True -- c1
      | b == e && e == h && h /= Nothing = True -- c2
      | c == f && f == i && i /= Nothing = True -- c3
      | otherwise                        = False

play :: IO()
play =
  putStrLn "Hello and welcome to TicTacToe" >>
  gameLoop initState X
