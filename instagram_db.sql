DROP DATABASE IF EXISTS instagram_db;
CREATE DATABASE instagram_db;
USE instagram_db;

-- Вимикаємо перевірку зовнішніх ключів для перестворення таблиць
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS story_comments;
DROP TABLE IF EXISTS story_reactions;
DROP TABLE IF EXISTS followers;
DROP TABLE IF EXISTS stories;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- 2. Створення таблиць
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
) ENGINE = INNODB;

CREATE TABLE stories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    media_type VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL,
    expires_at DATETIME NOT NULL
) ENGINE = INNODB;

CREATE TABLE followers (
    follower_id BIGINT NOT NULL,
    followed_id BIGINT NOT NULL,
    PRIMARY KEY (follower_id, followed_id)
) ENGINE = INNODB;

CREATE TABLE story_reactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    story_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reaction_type VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL
) ENGINE = INNODB;

CREATE TABLE story_comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    story_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at DATETIME NOT NULL
) ENGINE = INNODB;

-- 3. Додавання зовнішніх ключів (Constraints)
ALTER TABLE stories
    ADD CONSTRAINT FK_stories_users
    FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE followers
    ADD CONSTRAINT FK_followers_follower
    FOREIGN KEY (follower_id) REFERENCES users (id),
    ADD CONSTRAINT FK_followers_followed
    FOREIGN KEY (followed_id) REFERENCES users (id);

ALTER TABLE story_reactions
    ADD CONSTRAINT FK_story_reactions_stories
    FOREIGN KEY (story_id) REFERENCES stories (id),
    ADD CONSTRAINT FK_story_reactions_users
    FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE story_comments
    ADD CONSTRAINT FK_story_comments_stories
    FOREIGN KEY (story_id) REFERENCES stories (id),
    ADD CONSTRAINT FK_story_comments_users
    FOREIGN KEY (user_id) REFERENCES users (id);

-- 4. Створення двох додаткових індексів
CREATE INDEX idx_users_nickname ON users(nickname);
CREATE INDEX idx_stories_created_at ON stories(created_at);

-- 5. Заповнення таблиць даними (INSERT)
INSERT INTO users (nickname, email) VALUES
('oleh_politech', 'oleh.politech@example.com'),
('marko_lead', 'marko.lead@example.com'),
('artem_iot', 'artem.iot@example.com'),
('yuriy_strakh', 'yuriy.strakh@example.com'),
('ivan_dev', 'ivan.dev@example.com'),
('sasha_3d', 'sasha.3d@example.com'),
('denys_sport', 'denys.sport@example.com'),
('danylo_travel', 'danylo.travel@example.com'),
('andriy_circuits', 'andriy.circuits@example.com'),
('yura_bio', 'yura.bio@example.com');

INSERT INTO stories (user_id, media_url, media_type, created_at, expires_at) VALUES
(1, 'http://img.com/lviv_poly.jpg', 'PHOTO', NOW() - INTERVAL 2 HOUR, NOW() + INTERVAL 22 HOUR),
(1, 'http://vid.com/arduino.mp4', 'VIDEO', NOW() - INTERVAL 4 HOUR, NOW() + INTERVAL 20 HOUR),
(2, 'http://img.com/code_review.jpg', 'PHOTO', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 23 HOUR),
(3, 'http://img.com/iot_lab.jpg', 'PHOTO', NOW() - INTERVAL 10 HOUR, NOW() + INTERVAL 14 HOUR),
(4, 'http://img.com/pryvokzalna.jpg', 'PHOTO', NOW() - INTERVAL 12 HOUR, NOW() + INTERVAL 12 HOUR),
(5, 'http://vid.com/gym.mp4', 'VIDEO', NOW() - INTERVAL 15 HOUR, NOW() + INTERVAL 9 HOUR),
(6, 'http://img.com/blender_render.jpg', 'PHOTO', NOW() - INTERVAL 3 HOUR, NOW() + INTERVAL 21 HOUR),
(7, 'http://vid.com/pushups.mp4', 'VIDEO', NOW() - INTERVAL 5 HOUR, NOW() + INTERVAL 19 HOUR),
(8, 'http://img.com/carpathians.jpg', 'PHOTO', NOW() - INTERVAL 8 HOUR, NOW() + INTERVAL 16 HOUR),
(9, 'http://img.com/multisim.jpg', 'PHOTO', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 23 HOUR);

INSERT INTO followers (follower_id, followed_id) VALUES
(1, 2), (1, 3), (1, 4), (2, 1), (3, 1), 
(4, 1), (5, 1), (6, 1), (7, 1), (8, 1), 
(9, 1), (10, 1), (2, 3), (3, 2), (4, 5);

INSERT INTO story_reactions (story_id, user_id, reaction_type, created_at) VALUES
(1, 2, 'LIKE', NOW() - INTERVAL 1 HOUR),
(1, 3, 'FIRE', NOW() - INTERVAL 1 HOUR),
(2, 4, 'HEART', NOW() - INTERVAL 2 HOUR),
(4, 1, 'LIKE', NOW() - INTERVAL 5 HOUR),
(5, 2, 'FIRE', NOW() - INTERVAL 3 HOUR),
(6, 1, 'WOW', NOW() - INTERVAL 10 HOUR),
(7, 1, 'FIRE', NOW() - INTERVAL 2 HOUR),
(8, 1, 'HEART', NOW() - INTERVAL 4 HOUR),
(9, 1, 'LIKE', NOW() - INTERVAL 6 HOUR),
(10, 1, 'LIKE', NOW() - INTERVAL 30 MINUTE),
(1, 5, 'LIKE', NOW() - INTERVAL 45 MINUTE),
(2, 6, 'WOW', NOW() - INTERVAL 1 HOUR);

INSERT INTO story_comments (story_id, user_id, comment_text, created_at) VALUES
(1, 2, 'Cool photo!', NOW() - INTERVAL 50 MINUTE),
(1, 3, 'Where is this?', NOW() - INTERVAL 45 MINUTE),
(1, 4, 'Looks great', NOW() - INTERVAL 40 MINUTE),
(1, 5, 'Nice shot', NOW() - INTERVAL 35 MINUTE),
(1, 6, 'Lviv Poly!', NOW() - INTERVAL 30 MINUTE),
(1, 7, 'Awesome', NOW() - INTERVAL 25 MINUTE),
(2, 4, 'Nice project', NOW() - INTERVAL 1 HOUR),
(7, 1, 'Great render!', NOW() - INTERVAL 1 HOUR),
(8, 2, 'Keep it up!', NOW() - INTERVAL 2 HOUR),
(9, 3, 'Looks cold there', NOW() - INTERVAL 3 HOUR);