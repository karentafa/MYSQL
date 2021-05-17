
/*
Assignment 1 PART 2, ATTEMPT 2
*/
use `karentaf_linkedin`;

#CREATE TABLES

CREATE TABLE `User_Account` (
	`Account_Type` varchar(255) NOT NULL,
    `Username` VARCHAR(255) NOT NULL,
	`Start_Date` DATE NOT NULL,
    `End_Date` DATE,
    `Monthly_Charge` FLOAT
)  ENGINE=INNODB; 

ALTER TABLE User_Account
ADD CONSTRAINT fk_username FOREIGN KEY(Username) REFERENCES Profile(Username);


ALTER TABLE User_Account
ADD CONSTRAINT fk_account_type FOREIGN KEY(Account_Type) REFERENCES Account_Type(Account_Type);
	


CREATE TABLE Account_Type (
	`Account_Type` varchar(255) NOT NULL PRIMARY KEY,
    `Monthly_Charge` float
)  ENGINE=INNODB;





CREATE TABLE `Profile` (
    `Username` VARCHAR(255) NOT NULL,
     `Gender` ENUM('F', 'M') NOT NULL,
     `Date_Of_Birth` DATE NOT NULL,
    `First_Name` VARCHAR(255) NOT NULL,
    `Last_Name` VARCHAR(255) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `City` VARCHAR(255) ,
    `Country` VARCHAR(255) ,
    `About` VARCHAR(255),
    PRIMARY KEY (`Username`)
)  ENGINE=INNODB;

ALTER TABLE User_Account
ADD COLUMN Start_Date  DATE;

ALTER TABLE User_Account
ADD COLUMN End_Date DATE;

ALTER TABLE Education
ADD COLUMN GPA  FLOAT;

CREATE TABLE `Experience` (
    `ExperienceID`  INT  NOT NULL AUTO_INCREMENT,
     `Username` VARCHAR(255) NOT NULL,
    `Title` VARCHAR(255) NOT NULL,
    `Employment_type` VARCHAR(255) NOT NULL,
    `Company` VARCHAR(255),
    `City` VARCHAR(255) ,
    `Country` VARCHAR(255) ,
     `Start_Date` DATE,
     `End_Date` DATE,
    PRIMARY KEY (`ExperienceID`),
    FOREIGN KEY (Username) REFERENCES Profile(Username)
)  ENGINE=INNODB;


CREATE TABLE `Education` (
    `EducationID` INT(255) NOT NULL AUTO_INCREMENT,
    `Username` VARCHAR(255) NOT NULL,
    `School` VARCHAR(255),
    `Degree` VARCHAR(255) ,
    `Field_of_study` VARCHAR(255),
    `Start_Date` DATE,
    `End_Date` DATE ,
    `GPA` FLOAT ,
    `Activities_and_societies` VARCHAR(255),
    `Description` VARCHAR(255) ,
    PRIMARY KEY (`EducationID`),
	FOREIGN KEY (Username) REFERENCES Profile(Username)
)  ENGINE=INNODB;

CREATE TABLE `Connections` (
    `Username` VARCHAR(255) NOT NULL PRIMARY KEY,
    Connection varchar(255),
    FOREIGN KEY (Username) REFERENCES Profile(Username),
    FOREIGN KEY (Connection) REFERENCES Profile(Username)
)  ENGINE=INNODB;

/*

*/


SELECT* FROM User_Account ;
SELECT* FROM Account_Type ;
SELECT* FROM Experience ;
SELECT* FROM User_Account ;
SELECT* FROM Connections ;
/*

*/



/*
Number 5
*/

#USING GROUP CONCAT BECAUSE A PERSON MIGHT HAVE  MORE THAN ONE FIRST CONNECTION AND WE NEED TO BE ABLE TO SEE ALL THEM
SELECT Profile.First_Name, Profile.Last_Name,Profile.Email, GROUP_CONCAT(Profile2.First_Name," ", Profile2.Last_Name, ", ", Profile2.Email SEPARATOR ',') AS 'Connections'
	FROM Profile
	JOIN Connections
		ON Connections.Username = Profile.Username
	JOIN Profile as Profile2
		ON Connections.Connection = Profile2.Username
	GROUP BY Profile.Email ;
    
/*
Number 6
*/

/*This shows the GPA, Title and Employment type. This could be helpful to see if GPA has an effect on Employment Type and Title/Position, this means that when recommending jobs to users, they could make the jobs more targeted toward them 
through the GPA*/

SELECT Profile.First_Name, Profile.Last_Name, Education.GPA, Experience.Title, Experience.Employment_type
FROM Experience
	JOIN Profile
		ON Experience.Username = Profile.Username
	JOIN Education
		ON Profile.Username = Education.Username;
        
        
        
  
  
  /*
  This shows a user and their connections' titles/position. This is helpful incase we want to see if users usually connect with people with the same positions as them. If thats the case, the algorithm can be 
  adjusted to push more people with similar roles out to the user
  
  */
        
CREATE VIEW user_connections AS
SELECT Profile.First_Name, Profile.Last_Name,Profile.Email, GROUP_CONCAT(Profile2.First_Name," ", Profile2.Last_Name, ", ", Profile2.Email SEPARATOR ',') AS 'Connections', Profile.Username AS user, Profile2.Username AS connection_username
	FROM Profile
	JOIN Connections
		ON Connections.Username = Profile.Username
	JOIN Profile as Profile2
		ON Connections.Connection = Profile2.Username
	GROUP BY Profile.Email ;
    

    
SELECT user_connections.First_Name, user_connections.Last_Name,  Experience.Title, user_connections.Connections, Experience2.Title AS Connection_Title
FROM Experience
	JOIN user_connections
		ON user_connections.user = Experience.Username
	JOIN  Experience AS Experience2
		ON user_connections.connection_username = Experience2.Username;
  /*
Number 7
*/
  


SELECT Profile.Username, Profile.First_Name, Profile.Last_Name,User_Account.Start_Date AS member_since,  ROUND(TIMESTAMPDIFF(MONTH, User_Account.Start_Date, '2020-12-31')* User_Account.Monthly_Charge,2) as total_due_2020
FROM Profile
	JOIN User_Account
		ON Profile.Username = User_Account.Username;
        

	