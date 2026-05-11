-- CirclO Social Platform - Sample Data Initialization
-- ≥15 entries per table, no NULLs, referential integrity

USE circlo_db;

-- 20 Users
INSERT INTO Users (username, email, password) VALUES
('alice', 'alice@circlo.com', 'pass123'), ('bob', 'bob@circlo.com', 'pass123'),
('charlie', 'charlie@circlo.com', 'pass123'), ('diana', 'diana@circlo.com', 'pass123'),
('eve', 'eve@circlo.com', 'pass123'), ('frank', 'frank@circlo.com', 'pass123'),
('grace', 'grace@circlo.com', 'pass123'), ('henry', 'henry@circlo.com', 'pass123'),
('ivy', 'ivy@circlo.com', 'pass123'), ('jack', 'jack@circlo.com', 'pass123'),
('kate', 'kate@circlo.com', 'pass123'), ('leo', 'leo@circlo.com', 'pass123'),
('mia', 'mia@circlo.com', 'pass123'), ('noah', 'noah@circlo.com', 'pass123'),
('olivia', 'olivia@circlo.com', 'pass123'), ('paul', 'paul@circlo.com', 'pass123'),
('quinn', 'quinn@circlo.com', 'pass123'), ('rachel', 'rachel@circlo.com', 'pass123'),
('sam', 'sam@circlo.com', 'pass123'), ('tina', 'tina@circlo.com', 'pass123');

-- 20 Posts (user_id 1-20)
INSERT INTO Posts (user_id, content) VALUES
(1, 'Welcome to CirclO! #social'), (2, 'Great day!'), (3, 'Learning Java JDBC'),
(4, 'MySQL tips'), (5, 'Hello friends'), (6, 'Weekend plans?'), (7, 'Coffee time'),
(8, 'New project'), (9, 'Team work'), (10, 'Coding fun'), (11, 'Database design'),
(12, 'SQL queries'), (13, 'Maven build'), (14, 'JDBC connection'), (15, 'Post feed'),
(16, 'User auth'), (17, 'Comments active'), (18, 'Reactions!'), (19, 'Connections'),
(20, 'Social platform live!');

-- 20 Comments (post_id 1-20, user_id cycle)
INSERT INTO Comments (post_id, user_id, content) VALUES
(1,2,'Nice!'), (2,3,'Yes!'), (3,4,'Cool'), (4,5,'Thanks'), (5,6,'Hi'), (6,7,'Party?'),
(7,8,'Yum'), (8,9,'Congrats'), (9,10,'Yes'), (10,1,'Fun!'), (11,2,'Good'),
(12,3,'Pro'), (13,4,'Works'), (14,5,'Connected'), (15,6,'Feed good'),
(16,7,'Secure'), (17,8,'Chatty'), (18,9,'Like'), (19,10,'Friends'),
(20,1,'Awesome!');

-- 20 Reactions (post_id 1-20, user_id 11-20 then 1-10, types like/heart/laugh)
INSERT INTO Reactions (post_id, user_id, reaction_type) VALUES
(1,11,'like'), (2,12,'heart'), (3,13,'laugh'), (4,14,'like'), (5,15,'heart'),
(6,16,'like'), (7,17,'heart'), (8,18,'laugh'), (9,19,'like'), (10,20,'heart'),
(11,1,'like'), (12,2,'heart'), (13,3,'laugh'), (14,4,'like'), (15,5,'heart'),
(16,6,'like'), (17,7,'heart'), (18,8,'laugh'), (19,9,'like'), (20,10,'heart');

-- 20 Connections (requester 1-10 to receiver 11-20, mix pending/accepted)
INSERT INTO Connections (requester_id, receiver_id, status) VALUES
(1,11,'accepted'), (2,12,'accepted'), (3,13,'pending'), (4,14,'accepted'),
(5,15,'accepted'), (6,16,'pending'), (7,17,'accepted'), (8,18,'accepted'),
(9,19,'pending'), (10,20,'accepted'), (11,1,'accepted'), (12,2,'accepted'),
(13,3,'pending'), (14,4,'accepted'), (15,5,'accepted'), (16,6,'pending'),
(17,7,'accepted'), (18,8,'accepted'), (19,9,'pending'), (20,10,'accepted');

-- 20 Projects (creator_id spread across users 1-10)
INSERT INTO Projects (creator_id, title, description, category, status) VALUES
(1,  'AI Study Buddy',           'Build an AI-powered study assistant that generates quizzes from notes', 'AI/ML', 'open'),
(2,  'Campus Event App',         'Mobile app for discovering and RSVPing to campus events in real time', 'Mobile', 'open'),
(3,  'Open Source LMS',          'Lightweight learning management system for small colleges', 'Web Dev', 'open'),
(4,  'Budget Tracker',           'Personal finance tracker with spending analytics and goal setting', 'Mobile', 'open'),
(5,  'Peer Code Review Tool',    'Platform where students submit code and get structured peer feedback', 'Web Dev', 'open'),
(6,  'Research Paper Summarizer','NLP tool that condenses academic papers into key bullet points', 'AI/ML', 'open'),
(7,  'Roommate Finder',          'Match students looking for roommates based on habits and location', 'Web Dev', 'open'),
(8,  'Hackathon Organizer',      'End-to-end platform to host and manage student hackathons', 'Web Dev', 'open'),
(9,  'AR Campus Tour',           'Augmented reality walking tour for prospective students', 'AR/VR', 'open'),
(10, 'Internship Board',         'Aggregator that pulls internship listings and matches them to skills', 'Web Dev', 'open'),
(1,  'Sign Language Translator', 'Computer vision model that translates hand signs to text in real time', 'AI/ML', 'open'),
(2,  'Mental Health Journal',    'Private journaling app with mood tracking and weekly insights', 'Mobile', 'open'),
(3,  'Collaborative Whiteboard', 'Real-time shared whiteboard for remote study sessions', 'Web Dev', 'open'),
(4,  'Student Marketplace',      'Buy and sell used textbooks and supplies between students', 'Web Dev', 'open'),
(5,  'Parking Spot Finder',      'IoT-connected app showing available parking spots on campus', 'IoT', 'open'),
(6,  'Flashcard Generator',      'Auto-generates spaced-repetition flashcards from uploaded PDFs', 'AI/ML', 'open'),
(7,  'Club Management System',   'Dashboard for student clubs to manage members, events, and budgets', 'Web Dev', 'open'),
(8,  'Green Campus Tracker',     'Track and gamify sustainable actions taken by students on campus', 'Mobile', 'open'),
(9,  'Virtual Lab Simulator',    'Web-based physics and chemistry lab simulations for online students', 'Web Dev', 'closed'),
(10, 'Alumni Network App',       'Connect current students with alumni for mentorship and referrals', 'Mobile', 'open');

-- 20 Applications (applicant_id from users 11-20, project_id 1-20)
INSERT INTO Applications (project_id, applicant_id, message, status) VALUES
(1,  11, 'I have experience with PyTorch and NLP — would love to build the quiz engine', 'accepted'),
(2,  12, 'I am a React Native developer looking for a real-world project to add to my portfolio', 'accepted'),
(3,  13, 'I have worked on open-source Django projects and can help with the backend', 'pending'),
(4,  14, 'Finance and mobile are my strengths — I built a similar app for a class project', 'accepted'),
(5,  15, 'I want to improve code quality culture at SJSU and this project aligns perfectly', 'accepted'),
(6,  16, 'Currently taking NLP course and looking to apply transformers in a real project', 'pending'),
(7,  17, 'I am looking for roommates myself and want to build the tool that solves the problem', 'accepted'),
(8,  18, 'I organized two hackathons before and can design the scoring and judging system', 'accepted'),
(9,  19, 'I have Unity and ARCore experience and am excited about immersive campus experiences', 'pending'),
(10, 20, 'I scraped LinkedIn job data before and can build the matching algorithm', 'accepted'),
(11, 11, 'Computer vision is my focus area — I have a working hand landmark detection prototype', 'accepted'),
(12, 12, 'Mental health is important to me — I want to design a calming, accessible UI for this', 'pending'),
(13, 13, 'I have built WebSocket apps before and can handle the real-time sync layer', 'accepted'),
(14, 14, 'E-commerce and marketplace logic is something I have implemented in two past projects', 'accepted'),
(15, 15, 'I have Raspberry Pi and sensor experience that would work well for the IoT backend', 'pending'),
(16, 16, 'PDF parsing and spaced repetition algorithms are topics I researched last semester', 'accepted'),
(17, 17, 'I am VP of a campus club and know exactly what features a club dashboard needs', 'accepted'),
(18, 18, 'I want to make sustainability fun — I can handle gamification and leaderboard logic', 'pending'),
(19, 19, 'Physics simulations are my specialty — I have built a 2D simulation engine in JavaScript', 'rejected'),
(20, 20, 'I interned at LinkedIn and have domain knowledge to make the alumni matching effective', 'accepted');

