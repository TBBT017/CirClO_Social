-- CirclO Social Platform - Database Schema Creation
-- MySQL 8

CREATE DATABASE IF NOT EXISTS circlo_db;
USE circlo_db;

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Posts table
CREATE TABLE IF NOT EXISTS Posts (
    post_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT  NOT NULL,
    content    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE IF NOT EXISTS Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT  NOT NULL,
    user_id    INT  NOT NULL,
    content    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Reactions table
CREATE TABLE IF NOT EXISTS Reactions (
    reaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    post_id       INT         NOT NULL,
    user_id       INT         NOT NULL,
    reaction_type VARCHAR(20) NOT NULL,
    created_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_reaction (post_id, user_id)
);

-- Connections table
CREATE TABLE IF NOT EXISTS Connections (
    connection_id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id  INT         NOT NULL,
    receiver_id   INT         NOT NULL,
    status        VARCHAR(20) DEFAULT 'pending',
    created_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (requester_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id)  REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_connection (requester_id, receiver_id)
);

-- Projects table (student idea board)
CREATE TABLE IF NOT EXISTS Projects (
    project_id  INT AUTO_INCREMENT PRIMARY KEY,
    creator_id  INT          NOT NULL,
    title       VARCHAR(200) NOT NULL,
    description TEXT         NOT NULL,
    category    VARCHAR(50)  NOT NULL,
    status      VARCHAR(20)  DEFAULT 'open',
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Applications table (requests to join a project)
CREATE TABLE IF NOT EXISTS Applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id     INT          NOT NULL,
    applicant_id   INT          NOT NULL,
    message        TEXT         NOT NULL,
    status         VARCHAR(20)  DEFAULT 'pending',
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id)   REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (applicant_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (project_id, applicant_id)
);

-- Indexes for performance
CREATE INDEX idx_posts_user_id           ON Posts(user_id);
CREATE INDEX idx_comments_post_id        ON Comments(post_id);
CREATE INDEX idx_reactions_post_id       ON Reactions(post_id);
CREATE INDEX idx_connections_requester   ON Connections(requester_id);
CREATE INDEX idx_connections_receiver    ON Connections(receiver_id);
CREATE INDEX idx_projects_creator_id     ON Projects(creator_id);
CREATE INDEX idx_applications_project_id ON Applications(project_id);
CREATE INDEX idx_applications_applicant  ON Applications(applicant_id);
