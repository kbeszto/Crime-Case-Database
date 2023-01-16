DROP TABLE PoliceChief cascade constraints;
DROP TABLE Precinct cascade constraints;
DROP TABLE Detective cascade constraints;
DROP TABLE Cases cascade constraints;
DROP TABLE CriminalRiskLevel cascade constraints;
DROP TABLE Criminal cascade constraints;
DROP TABLE ForensicLab cascade constraints;
DROP TABLE PeopleOfInterest cascade constraints;
DROP TABLE Suspect cascade constraints;
DROP TABLE Witness cascade constraints;
DROP TABLE Victim cascade constraints;
DROP TABLE PhysicalEvidence cascade constraints;
DROP TABLE Statements cascade constraints;
DROP TABLE FollowUpReports cascade constraints;
DROP TABLE FirstIncidentReport cascade constraints;
DROP TABLE DetectiveCaseManagement cascade constraints;
DROP TABLE CrimeInCase cascade constraints;
DROP TABLE WorkWithPOI cascade constraints;
DROP TABLE CaseInvolvesPOI cascade constraints;
DROP TABLE CommitCrime cascade constraints;

CREATE TABLE PoliceChief(
    BadgeNumber INTEGER PRIMARY KEY,
    Name CHAR(30),
    PhoneNumber CHAR(12) UNIQUE);

CREATE TABLE Precinct (
    PrecinctNumber INTEGER PRIMARY KEY, 
    Address CHAR(30) UNIQUE);

CREATE TABLE Detective (
    DBadgeNumber INTEGER PRIMARY KEY,
    PCBadgeNumber INTEGER,
    PrecinctNumber INTEGER,
    Name CHAR(30),
    Rank CHAR(20),
    PhoneNumber CHAR(12) UNIQUE,
    FOREIGN KEY (PCBadgeNumber) REFERENCES PoliceChief(BadgeNumber), 
    FOREIGN KEY (PrecinctNumber) REFERENCES Precinct(PrecinctNumber));

CREATE TABLE Cases (
    CAID INTEGER PRIMARY KEY,
    DateLogged DATE,
    Result CHAR(20),
    CaseStatus CHAR(8));

CREATE TABLE CriminalRiskLevel ( 
    TimesArrested INTEGER PRIMARY KEY, 
    RiskLevel CHAR(8));

CREATE TABLE Criminal ( 
    CID INTEGER PRIMARY KEY,
    Name CHAR(30),
    TimesArrested INTEGER,
    FOREIGN KEY (TimesArrested) REFERENCES CriminalRiskLevel(TimesArrested));

CREATE TABLE ForensicLab (
    FID INTEGER PRIMARY KEY, 
    OfficeName CHAR(20), 
    OfficeAddress CHAR(30) UNIQUE);

CREATE TABLE PeopleOfInterest ( 
    ID INTEGER PRIMARY KEY, 
    Name CHAR(30),
    Address CHAR(30),
    Contact CHAR(40));

CREATE TABLE Suspect (
    ID INTEGER PRIMARY KEY,
    Reason CHAR(30),
    FOREIGN KEY (ID) REFERENCES PeopleOfInterest(ID));

CREATE TABLE Witness (
    ID INTEGER PRIMARY KEY,
    Protected CHAR(1),
    FOREIGN KEY (ID) REFERENCES PeopleOfInterest(ID));

CREATE TABLE Victim (
    ID INTEGER PRIMARY KEY,
    CurrCondition CHAR(20),
    FOREIGN KEY (ID) REFERENCES PeopleOfInterest(ID));

CREATE TABLE PhysicalEvidence ( CAID INTEGER,
    EID INTEGER,
    FID INTEGER,
    DateCollected DATE, EvdSource CHAR(20),
    Type CHAR(40),
    PRIMARY KEY (CAID, EID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID), 
    FOREIGN KEY (FID) REFERENCES ForensicLab(FID));

CREATE TABLE Statements (
    CAID INTEGER,
    EID INTEGER,
    FID INTEGER,
    DateCollected DATE,
    EvdSource CHAR(40),
    PRIMARY KEY (CAID, EID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID), 
    FOREIGN KEY (FID) REFERENCES ForensicLab(FID));

CREATE TABLE FollowUpReports (CAID INTEGER,
    EID INTEGER,
    FID INTEGER,
    DateCollected DATE,
    EvdSource CHAR(20),
    Reason CHAR(30),
    FURID INTEGER UNIQUE,
    PRIMARY KEY (CAID, EID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID), 
    FOREIGN KEY (FID) REFERENCES ForensicLab(FID));

CREATE TABLE FirstIncidentReport ( 
    CAID INTEGER,
    EID INTEGER,
    FID INTEGER,
    DateCollected DATE, 
    EvdSource CHAR(20), 
    Reason CHAR(40),
    FIRID INTEGER UNIQUE, 
    PRIMARY KEY (CAID, EID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID), 
    FOREIGN KEY (FID) REFERENCES ForensicLab(FID));


CREATE TABLE DetectiveCaseManagement (
    BadgeNumber INTEGER,
    CAID INTEGER,
    PRIMARY KEY (BadgeNumber, CAID),
    FOREIGN KEY (BadgeNumber) REFERENCES Detective(DBadgeNumber), 
    FOREIGN KEY (CAID) REFERENCES Cases(CAID) ON DELETE CASCADE);

CREATE TABLE CrimeInCase (
    CAID INTEGER,
    CRID INTEGER,
    Location CHAR(20),
    CrimeType CHAR(20),
    PRIMARY KEY (CAID, CRID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID) ON DELETE CASCADE);

CREATE TABLE WorkWithPOI (
    BadgeNumber INTEGER,
    ID INTEGER,
    PRIMARY KEY(BadgeNumber, ID),
    FOREIGN KEY (BadgeNumber) REFERENCES Detective(DBadgeNumber), 
    FOREIGN KEY (ID) REFERENCES PeopleOfInterest(ID));
    
CREATE TABLE CaseInvolvesPOI (
    CAID INTEGER,
    ID INTEGER,
    PRIMARY KEY(CAID, ID),
    FOREIGN KEY (CAID) REFERENCES Cases(CAID), 
    FOREIGN KEY (ID) REFERENCES PeopleOfInterest(ID));

CREATE TABLE CommitCrime (
    CRID INTEGER,
    CID INTEGER,
    CAID INTEGER,
    PRIMARY KEY (CRID, CID, CAID),
    FOREIGN KEY (CID) REFERENCES Criminal(CID),
    FOREIGN KEY (CAID, CRID) REFERENCES CrimeInCase(CAID, CRID));


INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (100, 'Tyreke Beasley', '604-888-8888');
INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (200, 'Tyrone Moose', '604-456-4566');
INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (300, 'Tyler the Creator', '604-101-1010');
INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (400, 'Tyra Banks', '604-289-9820');
INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (500, 'Tyler Relyt', '604-604-6040');
INSERT INTO PoliceChief(BadgeNumber, Name, PhoneNumber) VALUES (1, 'Tyler1', '604-234-4355');

INSERT INTO Precinct(PrecinctNumber, Address) VALUES (95, '5603 Charming Ave');
INSERT INTO Precinct(PrecinctNumber, Address) VALUES (96, '8888 University Blvd');
INSERT INTO Precinct(PrecinctNumber, Address) VALUES (97, '5555 West Mall St');
INSERT INTO Precinct(PrecinctNumber, Address) VALUES (98, '9023 Pender St');
INSERT INTO Precinct(PrecinctNumber, Address) VALUES (99, '1000 Jake St');

INSERT INTO Detective(DBadgeNumber, PCBadgeNumber, PrecinctNumber, Name, Rank, PhoneNumber) VALUES (1, 100, 95, 'Batman', 'Vigilante', '888-888-8888');
INSERT INTO Detective(DBadgeNumber, PCBadgeNumber, PrecinctNumber, Name, Rank, PhoneNumber) VALUES (2, 100, 95, 'Jim Gordon', 'Lieutenant', '487-581-2945');
INSERT INTO Detective(DBadgeNumber, PCBadgeNumber, PrecinctNumber, Name, Rank, PhoneNumber) VALUES (3, 200, 96, 'Sherlock Holmes', 'Chief', '555-555-5555');
INSERT INTO Detective(DBadgeNumber, PCBadgeNumber, PrecinctNumber, Name, Rank, PhoneNumber) VALUES (4, 300, 97, 'Inspector Gadget', 'Inspector', '234-432-1234');
INSERT INTO Detective(DBadgeNumber, PCBadgeNumber, PrecinctNumber, Name, Rank, PhoneNumber) VALUES (5, 300, 97, 'Curious George', 'Inspector', '180-222-3343');

INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800001, DATE '2022-06-06', 'N/A', 'Active');
INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800002, DATE '2022-11-10', 'N/A', 'Active');
INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800003, DATE '2022-05-18', 'N/A', 'Active');   
INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800004, DATE '2022-07-11', 'Guilty','Inactive');
INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800005, DATE '2022-01-05', 'Dead', 'Inactive');
INSERT INTO Cases(CAID, DateLogged, Result, CaseStatus) VALUES (1800006, DATE '2022-11-22', 'Dead', 'Inactive');

INSERT INTO CriminalRiskLevel(TimesArrested, RiskLevel) VALUES (70, 'High');
INSERT INTO CriminalRiskLevel(TimesArrested, RiskLevel) VALUES (1, 'Low');
INSERT INTO CriminalRiskLevel(TimesArrested, RiskLevel) VALUES (54, 'Mid');
INSERT INTO CriminalRiskLevel(TimesArrested, RiskLevel) VALUES (0, 'Low');
INSERT INTO CriminalRiskLevel(TimesArrested, RiskLevel) VALUES (9999, 'EXTREME');

INSERT INTO Criminal(CID, Name, TimesArrested) VALUES (1, 'Jawa', 9999);
INSERT INTO Criminal(CID, Name, TimesArrested) VALUES (2, 'Walter White', 1);
INSERT INTO Criminal(CID, Name, TimesArrested) VALUES (3, 'Riddler', 54);
INSERT INTO Criminal(CID, Name, TimesArrested) VALUES (4, 'Jack the Ripper', 0);
INSERT INTO Criminal(CID, Name, TimesArrested) VALUES (5, 'Chuck E. Cheese', 70);

INSERT INTO ForensicLab(FID, OfficeName, OfficeAddress) VALUES (15, 'Flesh Sweeper', '555 Death St');
INSERT INTO ForensicLab(FID, OfficeName, OfficeAddress) VALUES (16, 'We Love Evidence!', '723 Yummy Dr');
INSERT INTO ForensicLab(FID, OfficeName, OfficeAddress) VALUES (17, '4ensics 4lyfe', '809 Patrice St');
INSERT INTO ForensicLab(FID, OfficeName, OfficeAddress) VALUES (18, 'Peter', '111 Peter St');
INSERT INTO ForensicLab(FID, OfficeName, OfficeAddress) VALUES (19, 'Lois', '222 Lois Rd');

INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (1, 'Peter Griffin', '31 Spooner St', 'petergriffinfunny@yahoo.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (2, 'Eric Cartman', '1542 Colorado Spring Rd', 'respectmahauthoritah@southpark.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (3, 'Tyler Blevins', '9400 San Francisco St', 'ninja@twitch.tv');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (4, 'John Cena', '5545 BingQilin Ave', 'cantseeme@wwe.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (5, 'Pooh Shiesty', '420 Drill Rd', 'reallyshiesty@rapper.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (6, 'Lebron James', '0623 Goat Dr', 'goat@nba.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (7, 'Odell Beckham Jr.', '1313 One Hand St', 'obj@nfl.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (8, 'Dave Chappelle', '2134 Comedy St', 'davechappelle@comedy.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (9, 'Will Smith', '2451 Bel Air Dr', 'wildwest@acting.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (10, 'Chris Rock', '4444 Oscar St', 'slapped@acting.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (11, 'Mr. Bean', '0592 Great St', 'mrbean@acting.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (12, 'Undertaker', '100-5055 Forsyth Commerce Rd', 'undertaker@wwe.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (13, 'Patrick Star', '2 Rock St', 'starpatrick@bbmail.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (14, 'Homer Simpson', '742 Evergreen Terrace', 'homesimp@smail.com');
INSERT INTO PeopleOfInterest (ID, Name, Address, Contact) VALUES (15, 'Bender Rodríguez', '#1 Apt The Future', 'bitemyshinymetal@ssfuture.com');

INSERT INTO Suspect(ID, Reason) VALUES (1, 'Too Funny!');
INSERT INTO Suspect(ID, Reason) VALUES (13, 'Under his rock all the time');
INSERT INTO Suspect(ID, Reason) VALUES (4, 'Can’t see this man');
INSERT INTO Suspect(ID, Reason) VALUES (5, 'Acting suspicious');
INSERT INTO Suspect(ID, Reason) VALUES (9, 'Slapped Chris Rock');

INSERT INTO Witness (ID, Protected) VALUES (7, 'Y');
INSERT INTO Witness (ID, Protected) VALUES (15, 'N');
INSERT INTO Witness (ID, Protected) VALUES (8, 'Y');
INSERT INTO Witness (ID, Protected) VALUES (2, 'Y');
INSERT INTO Witness (ID, Protected) VALUES (11, 'N');

INSERT INTO Victim (ID, CurrCondition) VALUES (10, 'Bruise on cheek');
INSERT INTO Victim (ID, CurrCondition) VALUES (14, 'Two brain cells');
INSERT INTO Victim (ID, CurrCondition) VALUES (6, 'Sprained ankle');
INSERT INTO Victim (ID, CurrCondition) VALUES (3, 'Losing popularity');
INSERT INTO Victim (ID, CurrCondition) VALUES (12, 'Dead');

INSERT INTO WorkWithPOI(BadgeNumber, ID) VALUES (1, 1);
INSERT INTO WorkWithPOI(BadgeNumber, ID) VALUES (3, 9);
INSERT INTO WorkWithPOI(BadgeNumber, ID) VALUES (3, 10);
INSERT INTO WorkWithPOI(BadgeNumber, ID) VALUES (4, 14);
INSERT INTO WorkWithPOI(BadgeNumber, ID) VALUES (5, 6);

INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800001, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800002, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800003, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800004, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800005, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800006, 5);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800002, 7);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800003, 6);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800005, 9);
INSERT INTO CaseInvolvesPOI(CAID, ID) VALUES (1800005, 10);

INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800001, 1010, 'Downtown', 'Murder');
INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800002, 1015, 'Mount Pleasant', 'BE');
INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800002, 1010, 'Mount Pleasant', 'Murder');
INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800003, 1010, 'Yaletown', 'Murder');
INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800004, 1016, 'Waterfront', 'Drug Dealing');
INSERT INTO CrimeInCase(CAID, CRID, Location, CrimeType) VALUES (1800005, 1012, 'Downtown', 'Assault');

INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (1, 1800001);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (2, 1800002);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (3, 1800003);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (4, 1800004);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (5, 1800005);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (5, 1800006);
INSERT INTO DetectiveCaseManagement(BadgeNumber, CAID) VALUES (4, 1800006);

INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1010, 1, 1800001);
INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1010, 1, 1800002);
INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1016, 2, 1800004);
INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1015, 3, 1800002);
INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1010, 4, 1800003);
INSERT INTO CommitCrime(CRID, CID, CAID) VALUES (1012, 5, 1800005); 

INSERT INTO PhysicalEvidence(CAID, EID, FID, DateCollected, EvdSource, Type) VALUES (1800001, 511, 15, DATE '2022-06-06', 'Crime Scene', 'Weapon');
INSERT INTO PhysicalEvidence(CAID, EID, FID, DateCollected, EvdSource, Type) VALUES (1800002, 512, 16, DATE '1985-03-28', 'Crime Scene', 'Finger Prints');
INSERT INTO PhysicalEvidence(CAID, EID, FID, DateCollected, EvdSource, Type) VALUES (1800003, 513, 17, DATE '2000-12-25', 'WWE Cage', 'Foldable Chair');
INSERT INTO PhysicalEvidence(CAID, EID, FID, DateCollected, EvdSource, Type) VALUES (1800004, 514, 18, DATE '2008-05-30', 'Crime Scene', 'Drug');
INSERT INTO PhysicalEvidence(CAID, EID, FID, DateCollected, EvdSource, Type) VALUES (1800005, 515, 19, DATE '2021-10-10', 'National TV', 'Chris Rock’s hand');

INSERT INTO Statements(CAID, EID, FID, DateCollected, EvdSource) VALUES (1800001, 516, null, DATE '2022-06-06', 'Victim');
INSERT INTO Statements(CAID, EID, FID, DateCollected, EvdSource) VALUES (1800002, 512, null, DATE '1985-03-28', 'Witness');
INSERT INTO Statements(CAID, EID, FID, DateCollected, EvdSource) VALUES (1800003, 513, null, DATE '2000-12-25', 'Suspect A');
INSERT INTO Statements(CAID, EID, FID, DateCollected, EvdSource) VALUES (1800004, 514, null, DATE '2008-05-30', 'Victim’s Friend');
INSERT INTO Statements(CAID, EID, FID, DateCollected, EvdSource) VALUES (1800005, 515, null, DATE '2021-10-10', 'Witness');

INSERT INTO FollowUpReports (CAID, EID, FID, DateCollected, EvdSource, Reason, FURID) VALUES (1800001, 516, 15, DATE '2022-06-16', null, 'Reinterrogate', 606);
INSERT INTO FollowUpReports (CAID, EID, FID, DateCollected, EvdSource, Reason, FURID) VALUES (1800002, 512, 16, DATE '1985-04-10', null, 'New POI found', 607);
INSERT INTO FollowUpReports (CAID, EID, FID, DateCollected, EvdSource, Reason, FURID) VALUES (1800003, 513, 17, DATE '2000-12-31',null, 'New POI found', 608);
INSERT INTO FollowUpReports (CAID, EID, FID, DateCollected, EvdSource, Reason, FURID) VALUES (1800004, 514, 18, DATE '2008-06-25', null, 'New information found', 609);
INSERT INTO FollowUpReports (CAID, EID, FID, DateCollected, EvdSource, Reason, FURID) VALUES (1800005, 515, 19, DATE '2021-11-10', null, 'Reinterrogate', 610);

INSERT INTO FirstIncidentReport (CAID, EID, FID, DateCollected, EvdSource, Reason, FIRID) VALUES (1800001, 516, 15, DATE '2022-06-06', null, 'Reinterrogate', 606);
INSERT INTO FirstIncidentReport (CAID, EID, FID, DateCollected, EvdSource, Reason, FIRID) VALUES (1800002, 512, 16, DATE '1985-03-28', null, 'New POI found', 607);
INSERT INTO FirstIncidentReport (CAID, EID, FID, DateCollected, EvdSource, Reason, FIRID) VALUES (1800003, 513, 17, DATE '2000-12-25', null, 'New POI found', 608);
INSERT INTO FirstIncidentReport (CAID, EID, FID, DateCollected, EvdSource, Reason, FIRID) VALUES (1800004, 514, 18, DATE '2008-05-30', null, 'New information found', 609);
INSERT INTO FirstIncidentReport (CAID, EID, FID, DateCollected, EvdSource, Reason, FIRID) VALUES (1800005, 515, 19, DATE '2021-10-10', null, 'Reinterrogate', 610);

COMMIT;