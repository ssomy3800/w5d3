PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL 
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    parent_question INTEGER NOT NULL, 
    parent_reply_id INTEGER,
    user_id INTEGER NOT NULL, 
    question_body TEXT NOT NULL,
    FOREIGN KEY(parent_question) REFERENCES questions(id),
    FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO users (fname, lname)
VALUES ("Hong", "Chen"), ("Matt", "Pierson"), ("DR", "David");

INSERT INTO questions(title, body, author_id)
VALUES ("why am i still here", "IDK", 1), ("It doesn't make sense", "I HATE SQL", 2), ("HAIRCUT DAY WHEN", "make rail 2 easier", 3);

INSERT INTO question_follows(question_id, user_id) VALUES (1,1),(1,2),(1,3);

INSERT INTO replies(parent_question, parent_reply_id, user_id, question_body) VALUES (1,NULL,1,"idk random word");

INSERT INTO question_likes(user_id, question_id) VALUES (1,1),(1,2);