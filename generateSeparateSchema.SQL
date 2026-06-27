-----------------------------------------------
-- MICROSERVICE : UTILISATEURS (User Service)
-----------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_user_db`;
USE `ycyw_user_db`;

CREATE TABLE `User` (
    `id` CHAR(36) PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `firstName` VARCHAR(255) NOT NULL,
    `password` TEXT NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `role` ENUM('ADMIN', 'CLIENT')
);


-- MICROSERVICE : AGENCES (Agency Service)

CREATE SCHEMA IF NOT EXISTS `ycyw_agency_db`;
USE `ycyw_agency_db`;

CREATE TABLE `Agency` (
    `id` CHAR(36) PRIMARY KEY,
    `adress` TEXT,
    `email` VARCHAR(255) NOT NULL,
    `phoneNumber` VARCHAR(50) NOT NULL
);

------------------------------------------------
-- MICROSERVICE : VÉHICULES (Vehicle Service)
------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_vehicle_db`;
USE `ycyw_vehicle_db`;

CREATE TABLE `Vehicle` (
    `id` CHAR(36) PRIMARY KEY,
    `make` VARCHAR(255) NOT NULL,
    `model` VARCHAR(255) NOT NULL,
    `pictureURL` VARCHAR(255),
    `category` VARCHAR(255) NOT NULL, -- Devrait idéalement suivre la norme ACRISS (ex: CDMR)
    `price_per_day` DECIMAL(10,2)
);

----------------------------------------------------
-- MICROSERVICE : SUPPORT CLIENT (Ticket Service)
----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_support_db`;
USE `ycyw_support_db`;

CREATE TABLE `Ticket` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL, -- Référence logique vers ycyw_user_db.User(id) (Pas de FK)
    `message` TEXT,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `subject` VARCHAR(255),
    `statut` ENUM('OPEN', 'IN PROGRESS', 'RESOLVED', 'PENDING')
);

--------------------------------------------------------
-- MICROSERVICE : RÉSERVATIONS (Reservation Service)
--------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_reservation_db`;
USE `ycyw_reservation_db`;

CREATE TABLE `Reservation` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL,         -- Référence logique vers ycyw_user_db.User(id)
    `vehicle_id` CHAR(36) NOT NULL,      -- Référence logique vers ycyw_vehicle_db.Vehicle(id)
    `startAgency_id` CHAR(36) NOT NULL,  -- Référence logique vers ycyw_agency_db.Agency(id)
    `endAgency_id` CHAR(36) NOT NULL,    -- Référence logique vers ycyw_agency_db.Agency(id)
    `startDate` TIMESTAMP,
    `endDate` TIMESTAMP,
    `creationDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- Note : Toutes les contraintes FK ont été supprimées pour isoler le service
);

-------------------------------------------------
-- MICROSERVICE : PAIEMENTS (Payment Service)
-------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_payment_db`;
USE `ycyw_payment_db`;

CREATE TABLE `Payment` (
    `id` CHAR(36) PRIMARY KEY,
    `reservation_id` CHAR(36) NOT NULL, -
    `date_paiment` TIMESTAMP,
    `statut` ENUM('PENDING', 'DONE', 'REJECTED'),
    `mode_payment` ENUM('CB', 'PAYPAL', 'STRIPE')-
);

---------------------------------------------------------
-- MICROSERVICE : NOTIFICATIONS
---------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ycyw_notification_db`;
USE `ycyw_notification_db`;

CREATE TABLE `Notification` (
    `id` CHAR(36) PRIMARY KEY,
    `user_id` CHAR(36) NOT NULL,         -- Destinataire
    `reservation_id` CHAR(36),           -- Reservation
    
    `type` ENUM(
        'RESERVATION_CONFIRMED', 
        'PAYMENT_VALIDATED', 
        'VEHICLE_PICKED_UP', 
        'VEHICLE_RETURNED', 
        'CANCELED'
    ) NOT NULL,
    
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `sent_at` TIMESTAMP NULL
);
