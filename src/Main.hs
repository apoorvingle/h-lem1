module Main where

import Data.Set (Set)
import qualified Data.Set as Set

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

import LEM1.RoughSet (leq
                     , (<=*)
                     , upper_approx
                     , lower_approx
                     )

import Model.Rules ( Rule
                   , checkRule
                   , ruleSetCoverage
                   , showRule
                   )

import Model.DataSet (DataFrame
                     , Rows
                     -- , Column (SC, NC) 
                     , getAStar
                     , getDStar
                     , stripColumn
                     , showDF
                     )

import LEM1.Algorithm (convertToTuple
                      , computeLEM1
                      , getGlobalCovering
                      , computeRuleSet
                      , dropConditions )

r_star :: Set (Set Integer)
r_star = Set.fromList [ Set.fromList [1]
                      , Set.fromList [2,3]
                      , Set.fromList [4,5]
                      , Set.fromList [6,7]
                      , Set.fromList [8]
                      ]

x :: Set Integer
x = Set.fromList [1, 2, 3, 5, 7]


d_star :: Set (Set Int)
d_star = Set.fromList [ Set.fromList[1,2,3]
                      , Set.fromList[4]
                      , Set.fromList[5,6] ]

a_star :: Set (Set Int)
a_star = Set.fromList [ Set.fromList[1]
                      , Set.fromList[2]
                      , Set.fromList[3]
                      , Set.fromList[4]
                      , Set.fromList[5,6] ]
 
a_star' :: Set (Set Int)
a_star' = Set.fromList [ Set.fromList[1]
                       , Set.fromList[2]
                       , Set.fromList[3, 4]
                       , Set.fromList[5,6] ]

rs :: Rows
rs = Map.fromList [ (0, (["0.8", "0.3", "7.2"], "very-small"))
                  , (1, (["0.8", "1.1", "7.2"], "small"))
                  , (2, (["0.8", "1.1", "10.2"], "medium"))
                  , (3, (["1.2", "0.3", "10.2"], "medium"))
                  , (4, (["1.2", "2.3", "10.2"], "medium"))
                  , (5, (["2.0", "2.3", "10.2"], "high"))
                  , (6, (["2.0", "2.3", "15.2"], "very-high"))
                  ]

df :: DataFrame
df = (["A", "B", "C"], "D", rs)


df' :: DataFrame
df' = (["Color", "Temperature"], "Attitude", rs')

rs' :: Rows
rs' = Map.fromList [ (3, (["red", "medium"], "negative"))
                   , (4, (["red", "low"], "negative"))
                   , (5, (["yellow", "medium"], "negative"))
                   ]

main :: IO ()
main = do
  print "Hello World!"
  -- print $ ("{d}*: " ++ show d_star)
  -- print $ ("{a}*: " ++ show a_star)
  -- print $ ("{a'}*: " ++ show a_star')
  -- print $ leq a_star d_star
  -- print $ a_star <=* d_star'
  -- print $ upper_approx x r_star
  -- print $ lower_approx x r_star
  putStrLn "------------------------------"
  putStrLn $ showDF df
  print $ ("{a}*: " ++ (show $ getAStar df))
  print $ ("{d}*: " ++ (show $ getDStar df))
  print $ (getAStar df) <=* (getDStar df)
  putStrLn "------------------------------"
  putStrLn $ showDF (stripColumn "A" df)
  putStrLn $ ("{a}*: " ++ (show $ getAStar (stripColumn "A" df)))
  putStrLn $ ("{d}*: " ++ (show $ getDStar (stripColumn "A" df)))
  print $ (getAStar (stripColumn "A" df)) <=* (getDStar (stripColumn "A" df))
  putStrLn "------------------------------"
  putStrLn $ showDF (stripColumn "B" df)
  putStrLn $ ("{a}*: " ++ (show $ getAStar (stripColumn "B" df)))
  putStrLn $ ("{d}*: " ++ (show $ getDStar (stripColumn "B" df)))
  print $ (getAStar (stripColumn "B" df)) <=* (getDStar (stripColumn "B" df))
  putStrLn "------------------------------"
  putStrLn $ showDF (stripColumn "C" df)
  putStrLn $ ("{a}*: " ++ (show $ getAStar (stripColumn "C" df)))
  putStrLn $ ("{d}*: " ++ (show $ getDStar (stripColumn "C" df)))
  print $ (getAStar (stripColumn "C" df)) <=* (getDStar (stripColumn "C" df))
  putStrLn "------------------------------"
  putStrLn "------------------------------"
  putStrLn "------------------------------"
  print $ convertToTuple (df')
  putStrLn $ unlines $ Set.toList (Set.map (showRule) (computeRuleSet ("Attitude", "negative") df'))
  putStrLn "------------------------------"
  -- print $ upper_approx (Set.fromList [1,2,3]) (getAStar df)
  -- print $ lower_approx (Set.fromList [1,2,3]) (getAStar df) 
  -- print $ checkRule rule df
  -- print $ ruleSetCoverage ruleSet df
  -- putStrLn $ showRule rule
  -- putStrLn $ unlines (map showRule (Set.toList ruleSet))


rule :: Rule
rule = ([("A", "0.8"), ("B", "1.1")], ("D", "medium"))

ruleSet :: Set Rule
ruleSet = Set.fromList [ ([("A", "0.8"), ("B", "1.1")], ("D", "medium"))
                       , ([("A", "1.2")], ("D", "small"))
                       ]
