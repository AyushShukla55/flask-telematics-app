
-- 1. Create table structure if it doesn't exist
CREATE TABLE IF NOT EXISTS vehicle_telemetry (
    id SERIAL PRIMARY KEY,
    vehicle_id VARCHAR(50) NOT NULL,
    speed DOUBLE PRECISION NOT NULL,
    fuel_level DOUBLE PRECISION NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Clear existing entries for a clean slate
TRUNCATE TABLE vehicle_telemetry RESTART IDENTITY;

-- 3. Insert 20 realistic fleet telemetry logs
INSERT INTO vehicle_telemetry (vehicle_id, speed, fuel_level, status, timestamp) VALUES
    ('TRUCK-101', 65.5, 82.0, 'ACTIVE', NOW() - INTERVAL '2 hours'),
    ('TRUCK-102', 88.4, 45.0, 'SPEEDING', NOW() - INTERVAL '1 hour 50 minutes'),
    ('VAN-201', 0.0, 95.0, 'IDLE', NOW() - INTERVAL '1 hour 40 minutes'),
    ('VAN-202', 72.0, 15.5, 'LOW_FUEL', NOW() - INTERVAL '1 hour 30 minutes'),
    ('BUS-301', 92.1, 62.0, 'SPEEDING', NOW() - INTERVAL '1 hour 20 minutes'),
    ('BUS-302', 45.0, 78.5, 'ACTIVE', NOW() - INTERVAL '1 hour 10 minutes'),
    ('CAR-401', 58.0, 12.0, 'LOW_FUEL', NOW() - INTERVAL '1 hour'),
    ('CAR-402', 0.0, 88.0, 'IDLE', NOW() - INTERVAL '50 minutes'),
    ('TRUCK-103', 74.2, 54.0, 'ACTIVE', NOW() - INTERVAL '45 minutes'),
    ('TRUCK-104', 98.0, 31.0, 'SPEEDING', NOW() - INTERVAL '40 minutes'),
    ('VAN-203', 0.0, 8.5, 'LOW_FUEL', NOW() - INTERVAL '35 minutes'),
    ('VAN-204', 68.0, 71.0, 'ACTIVE', NOW() - INTERVAL '30 minutes'),
    ('BUS-303', 85.6, 42.0, 'SPEEDING', NOW() - INTERVAL '25 minutes'),
    ('BUS-304', 52.0, 90.0, 'ACTIVE', NOW() - INTERVAL '20 minutes'),
    ('CAR-403', 0.0, 100.0, 'IDLE', NOW() - INTERVAL '15 minutes'),
    ('CAR-404', 89.5, 18.0, 'SPEEDING', NOW() - INTERVAL '10 minutes'),
    ('TRUCK-105', 61.0, 67.0, 'ACTIVE', NOW() - INTERVAL '8 minutes'),
    ('VAN-205', 55.4, 14.2, 'LOW_FUEL', NOW() - INTERVAL '5 minutes'),
    ('BUS-305', 0.0, 80.0, 'IDLE', NOW() - INTERVAL '2 minutes'),
    ('CAR-405', 70.0, 50.0, 'ACTIVE', NOW());
