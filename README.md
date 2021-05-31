note: I made this back in 2016 for Philpax to demonstrate a bug. Ignore this.

# BugTest
A test for bug that occurs in certain circumstances when teleporting a player while in CalcView

/test or J to run the test
(/test command can be changed inside :PlayerChat in sBugTest.lua and "J" key in :KeyUp in cBugTest.lua)

Course of script's actions:

1- teleports the player to plateau near Desert Peak
2- activates CalcView(false) shortly after
3- teleports player to Salad Island beach shortly after
4- deactivates CalcView

