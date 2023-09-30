GRANT USAGE ON SCHEMA neximp001s1 TO npr001sunami;

-- Users table with primary key 'id'
CREATE TABLE neximp001s1.users (
    id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    email VARCHAR (255) UNIQUE NOT NULL,
    hash VARCHAR (255) NOT NULL,
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
    --is_private BOOLEAN NOT NULL --I didn't want this
);

--Quizzes table with primary key 'id' and a foreign key 'user_id' referencing 'users(id)'
CREATE TABLE neximp001s1.quizzes (
    id serial PRIMARY KEY,
    title VARCHAR (100) NOT NULL,
    description TEXT,
    user_id INT NOT NULL REFERENCES neximp001s1.users(id), -- The user who created the quiz
	tag_id INT NOT NULL REFERENCES neximp001s1.tags(id),
	flag_id INT NOT NULL REFERENCES neximp001s1.flags(id),
    is_private BOOLEAN NOT NULL, -- Indicates whether the quiz is public or private
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

--general question
-- Questions table with primary key 'id', a foreign key 'user_id' referencing 'users(id',
-- and an optional foreign key 'quiz_id' referencing 'quizzes(id)'
CREATE TABLE neximp001s1.questions (
    id serial PRIMARY KEY,
    --quiz_id INT NOT NULL, --The quiz to which the question belongs --questions are now independent
    question TEXT NOT NULL,
    type VARCHAR (20) NOT NULL, --m/c t/f
	user_id INT NOT NULL REFERENCES neximp001s1.users(id),
	tag_id INT NOT NULL REFERENCES neximp001s1.tags(id),
	flag_id INT NOT NULL REFERENCES neximp001s1.flags(id),
	is_private BOOLEAN NOT NULL,
	question_bank_id INT NOT NULL REFERENCES neximp001s1.question_bank(id),
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
	--quiz_id INT, -- An optional reference to the quiz to which the question belongs
    --FOREIGN KEY (quiz_id) REFERENCES quizzes(id)
);
	
--for multiple choice
-- Choices table with primary key 'id' and a foreign key 'question_id' referencing 'questions(id)'
CREATE TABLE neximp001s1.choices (
    id serial PRIMARY KEY,
    question_id INT NOT NULL REFERENCES neximp001s1.questions(id),
    choice json NOT NULL,
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

-- User quiz attempts table with primary key 'id', foreign keys 'user_id' and 'quiz_id' referencing 'users(id)' and 'quizzes(id)'
CREATE TABLE neximp001s1.user_quiz_attempts (
    id serial PRIMARY KEY,
    user_id INT NOT NULL REFERENCES neximp001s1.users(id),
    quiz_id INT NOT NULL REFERENCES neximp001s1.quizzes(id),
    score_id INT NOT NULL REFERENCES neximp001s1.scores(id),
    attempt_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	-- Add columns for user's flagged questions and other information
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);
--could have another table for the questions having a score, not just the quiz
--want the user to be able to track their success on a question

CREATE TABLE neximp001s1.user_questions_attempts (
    id serial PRIMARY KEY,
    user_id INT NOT NULL REFERENCES neximp001s1.users(id),
    question_id INT NOT NULL REFERENCES neximp001s1.questions(id),
    score_id INT NOT NULL REFERENCES neximp001s1.scores(id),
    attempt_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	-- Add columns for user's flagged questions and other information
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE neximp001s1.scores (
    id serial PRIMARY KEY,
	score_correct INT DEFAULT 0, 
	score_wrong INT DEFAULT 0,
	score_percentage INT DEFAULT 0,
    -- Add any additional columns as needed, e.g., display order within the quiz
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE neximp001s1.flags (
    id serial PRIMARY KEY,
	flag BOOLEAN DEFAULT FALSE, 
    -- Add any additional columns as needed, e.g., display order within the quiz
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);


-- Quiz tags table with primary key 'id' and a foreign key 'quiz_id' referencing 'quizzes(id)'
CREATE TABLE neximp001s1.tags (
    id serial PRIMARY KEY,
    tag VARCHAR (25) NOT NULL,
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-many relationship table between quizzes and questions with foreign keys to 'quizzes(id)' and 'questions(id)'
--establish the many to many relationship between quizzes and questions
--foreign keys to the quizzes and questions tables and indicate which questions are part of which quizzes
CREATE TABLE neximp001s1.quiz_questions (
    id serial PRIMARY KEY,
	quiz_id INT NOT NULL REFERENCES neximp001s1.quizzes(id),
    question_id INT NOT NULL REFERENCES neximp001s1.questions(id),
    -- Add any additional columns as needed, e.g., display order within the quiz
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);

--serves as the repository for questions that don't belong to a specific quiz
-- Question bank table to serve as a repository for questions with a foreign key 'question_id' referencing 'questions(id)'
CREATE TABLE neximp001s1.question_bank (
    id serial PRIMARY KEY,
    --question_id INT NOT NULL REFERENCES neximp001s1.questions(id),
    -- Add any additional columns as needed
	is_private BOOLEAN NOT NULL,
	last_updated timestamp DEFAULT CURRENT_TIMESTAMP
);
