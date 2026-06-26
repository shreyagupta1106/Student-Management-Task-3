-- Student Management Database Project

-- Create Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Gender CHAR(1),
    Age INT,
    Grade VARCHAR(2),
    MathScore INT,
    ScienceScore INT,
    EnglishScore INT
);

-- Insert Records
INSERT INTO Students
(Name, Gender, Age, Grade, MathScore, ScienceScore, EnglishScore)
VALUES
('Aarav','M',16,'A',85,90,88),
('Priya','F',15,'A',92,89,95),
('Rohan','M',16,'B',78,82,80),
('Ananya','F',15,'A',95,94,96),
('Kabir','M',17,'C',65,70,68),
('Sneha','F',16,'B',88,85,90),
('Arjun','M',15,'A',91,87,84),
('Meera','F',17,'B',76,80,79),
('Vivaan','M',16,'C',72,75,70),
('Diya','F',15,'A',89,93,91);

-- Display All Students
SELECT * FROM Students;

-- Average Math Score
SELECT AVG(MathScore) AS AvgMathScore
FROM Students;

-- Average Science Score
SELECT AVG(ScienceScore) AS AvgScienceScore
FROM Students;

-- Average English Score
SELECT AVG(EnglishScore) AS AvgEnglishScore
FROM Students;

-- Top Performer
SELECT Name,
       (MathScore + ScienceScore + EnglishScore) AS TotalScore
FROM Students
ORDER BY TotalScore DESC
LIMIT 1;

-- Student Count by Grade
SELECT Grade,
       COUNT(*) AS StudentCount
FROM Students
GROUP BY Grade;

-- Average Score by Gender
SELECT Gender,
       AVG((MathScore + ScienceScore + EnglishScore)/3.0) AS AverageScore
FROM Students
GROUP BY Gender;

-- Students with Math Score Greater Than 80
SELECT *
FROM Students
WHERE MathScore > 80;

-- Update Grade
UPDATE Students
SET Grade = 'A'
WHERE Name = 'Rohan';

-- Verify Update
SELECT *
FROM Students
WHERE Name = 'Rohan';

-- ===========================
-- TASK 3 ADDITIONS
-- ===========================

CREATE TABLE IF NOT EXISTS Courses(
 CourseID INT PRIMARY KEY AUTO_INCREMENT,
 CourseName VARCHAR(50)
);

INSERT INTO Courses (CourseName) VALUES
('Mathematics'),('Science'),('English');

CREATE TABLE IF NOT EXISTS Enrollments(
 EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
 StudentID INT,
 CourseID INT,
 Marks INT,
 FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
 FOREIGN KEY(CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments(StudentID,CourseID,Marks) VALUES
(1,1,85),(2,1,92),(3,1,78),(4,1,95),(5,1,65),(6,1,88),(7,1,91),(8,1,76),(9,1,72),(10,1,89),
(1,2,90),(2,2,89),(3,2,82),(4,2,94),(5,2,70),(6,2,85),(7,2,87),(8,2,80),(9,2,75),(10,2,93),
(1,3,88),(2,3,95),(3,3,80),(4,3,96),(5,3,68),(6,3,90),(7,3,84),(8,3,79),(9,3,70),(10,3,91);

-- 1. Top student per course
SELECT c.CourseName,s.Name,e.Marks
FROM Enrollments e
JOIN Students s ON e.StudentID=s.StudentID
JOIN Courses c ON e.CourseID=c.CourseID
WHERE e.Marks=(SELECT MAX(Marks) FROM Enrollments WHERE CourseID=e.CourseID);

-- 2. Pass rate per course
SELECT c.CourseName,
COUNT(*) AS TotalStudents,
SUM(CASE WHEN Marks>=40 THEN 1 ELSE 0 END) AS Passed,
ROUND(SUM(CASE WHEN Marks>=40 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS PassRate
FROM Enrollments e
JOIN Courses c ON e.CourseID=c.CourseID
GROUP BY c.CourseName;

-- 3. Overall topper
SELECT s.StudentID,s.Name,SUM(e.Marks) AS TotalMarks
FROM Students s
JOIN Enrollments e ON s.StudentID=e.StudentID
GROUP BY s.StudentID,s.Name
ORDER BY TotalMarks DESC
LIMIT 1;

-- 4. Students enrolled in multiple courses
SELECT s.StudentID,s.Name,COUNT(e.CourseID) AS CoursesEnrolled
FROM Students s
JOIN Enrollments e ON s.StudentID=e.StudentID
GROUP BY s.StudentID,s.Name
HAVING COUNT(e.CourseID)>1;
