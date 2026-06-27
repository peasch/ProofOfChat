-- 1. CRÉATION DES TABLES INDÉPENDANTES

CREATE TABLE `User` (
    `id` CHAR(36) PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `firstName` VARCHAR(255) NOT NULL,
    `password` TEXT NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `createdAt` TIMESTAMP,
    `updatedAt` TIMESTAMP,
    `role` ENUM('ADMIN', 'CLIENT')
);

CREATE TABLE `Agency` (
    `id` CHAR(36) PRIMARY KEY,
    `adress` TEXT,
    `email` VARCHAR(255) NOT NULL,
    `phoneNumber` VARCHAR(50) NOT NULL
);

CREATE TABLE `Vehicle` (
    `id` CHAR(36) PRIMARY KEY,
    `make` VARCHAR(255) NOT NULL,
    `model` VARCHAR(255) NOT NULL,
    `pictureURL` VARCHAR(255),
    `category` VARCHAR(255) NOT NULL,
    `price_per_day` DECIMAL(10,2)
);

-- 2. CRÉATION DES TABLES AVEC DÉPENDANCES (Niveau 1)

CREATE TABLE `Ticket` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL,
    `message` TEXT,
    `createdAt` TIMESTAMP,
    `subject` VARCHAR(255),
    `statut` ENUM('OPEN', 'IN PROGRESS', 'RESOLVED', 'PENDING'),
    CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`)
);

CREATE TABLE `Reservation` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL,
    `vehicle_id` CHAR(36) NOT NULL,
    `startAgency_id` CHAR(36) NOT NULL,
    `endAgency_id` CHAR(36) NOT NULL,
    `startDate` TIMESTAMP,
    `endDate` TIMESTAMP,
    `creationDate` TIMESTAMP,
    CONSTRAINT `fk_reservation_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`),
    CONSTRAINT `fk_reservation_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicle`(`id`),
    CONSTRAINT `fk_reservation_startAgency` FOREIGN KEY (`startAgency_id`) REFERENCES `Agency`(`id`),
    CONSTRAINT `fk_reservation_endAgency` FOREIGN KEY (`endAgency_id`) REFERENCES `Agency`(`id`)
);

-- 3. CRÉATION DES TABLES AVEC DÉPENDANCES (Niveau 2)

CREATE TABLE `Payment` (
    `id` CHAR(36) PRIMARY KEY,
    `reservation_id` CHAR(36) NOT NULL,
    `date_paiment` TIMESTAMP,
    `statut` ENUM('PENDING', 'DONE', 'REJECTED'),
    `mode_payment` ENUM('CB', 'PAYPAL'),
    CONSTRAINT `fk_payment_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `Reservation`(`id`)
);

CREATE TABLE `Notification` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL,
    `reservation_id` CHAR(36),
    `type` ENUM(
        'RESERVATION_CONFIRMED', 
        'PAYMENT_VALIDATED',  
        'VEHICLE_PICKED_UP', 
        'VEHICLE_RETURNED', 
        'CANCELED'
    ) NOT NULL,
    `message` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `sent_at` TIMESTAMP NULL,
    
    -- Ajout des clés étrangères pointant vers User et Reservation
    CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`),
    CONSTRAINT `fk_notification_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `Reservation`(`id`)
